package google

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/kafka"
	"github.com/Shopify/sarama"
	redisv8 "github.com/go-redis/redis/v8"
	"google.golang.org/api/calendar/v3"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"log"
	"time"
)

var (
	ErrNoUpcomingEvent = errors.New("no upcoming event")
)

const (
	Active = iota
	Inactive
)

type GCalendar struct {
	date string
}

// getEventsList retrieves the list of events from a user's primary Google calendar.
func (gc *GCalendar) getEventsList(srv *calendar.Service) (*calendar.Events, error) {
	t := time.Now().Format(time.RFC3339)
	events, err := srv.Events.List("primary").
		ShowDeleted(false).
		SingleEvents(true).
		TimeMin(t).
		MaxResults(1).
		OrderBy("startTime").
		Do()

	if err != nil {
		return nil, fmt.Errorf("failed to retrieve next event gcalendar: %w", err)
	}

	return events, nil
}

// Parse saves in memory the nearest event so that it can be compared later on.
func (gc *GCalendar) Parse(srv *calendar.Service) error {
	// Retrieves all events from the user's calendar.
	events, err := gc.getEventsList(srv)
	if err != nil {
		return fmt.Errorf("failed to get events list gcalendar: %w", err)
	}

	// If there are no upcoming events in the user's calendar, there's nothing more to do.
	if len(events.Items) == 0 {
		return ErrNoUpcomingEvent
	}

	// As the event list is ordered with the nearest event as the last element of the list
	// we save it in a temporary memory in the GCalendar.date placeholder so that we can
	// compare it later on with the last value we got in the Redis DB.
	for _, item := range events.Items {
		gc.date = item.Start.DateTime
		if gc.date == "" {
			gc.date = item.Start.Date
		}
	}

	return nil
}

// LookForChange compares the current date and the nearest event's date.
// It there's less than 10 minutes between these two events, the action can be triggered.
func (gc *GCalendar) LookForChange(op *operator.IdefixOperator, key, old string) error {
	// Sets the two elements to compare.
	now := time.Now()
	agendaDate := gc.date

	// Update the date to match the RFC3339 date format so that it can be compared.
	parse, err := time.Parse(time.RFC3339, agendaDate)
	if err != nil {
		log.Fatalln(err)
	}

	// Gets the time left before the nearest event and now.
	res := parse.Sub(now)
	if res.Minutes() >= 0 && res.Minutes() <= 10 {
		// The action can trigger.
		if old == string(rune(Inactive)) {
			err := op.RC.UpdateRedisState(key, string(rune(Active)))
			if err != nil {
				return fmt.Errorf("failed to update redis state: %w", err)
			}

			err = gc.SendToKafka(op.KP, key)
			if err != nil {
				return fmt.Errorf("failed to send message to kafka: %w", err)
			}
		} else if old == string(rune(Active)) {
			return nil
		}
	} else {
		// There's nothing in the range of < 10 minutes.
		err := op.RC.UpdateRedisState(key, string(rune(Inactive)))
		if err != nil {
			return fmt.Errorf("failed to update redis state: %w", err)
		}
	}

	return nil
}

// SendToKafka sends the task ID to Kafka.
func (gc *GCalendar) SendToKafka(kp sarama.SyncProducer, taskID string) error {
	data, err := json.Marshal(kafka.Action{TaskID: taskID})
	if err != nil {
		return fmt.Errorf("failed to marshal: %w", err)
	}

	msg := producer.PreparePublish("google", data)

	_, _, err = kp.SendMessage(msg)
	if err != nil {
		return fmt.Errorf("failed to send message to kafka: %w", err)
	}

	return nil
}

func (gc *GCalendar) GetRedisState(rc *redis.Client, key string) (string, error) {
	state, err := rc.GetKey(key)
	if errors.Is(err, redisv8.Nil) {
		err = rc.SetKey(key, string(rune(Inactive)))
		if err != nil {
			return "", fmt.Errorf("failed to set value in redis: %w", err)
		}
	} else if err != nil {
		return "", fmt.Errorf("failed to get value from redis: %w", err)
	}

	return state, nil
}
