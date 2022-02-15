package google

import (
	"encoding/json"
	"fmt"
	"github.com/Shopify/sarama"
	redisv8 "github.com/go-redis/redis/v8"
	"google.golang.org/api/calendar/v3"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"log"
	"time"
)

const (
	ACTIVE = iota
	NO_ACTIVE
)

type GCalendar struct {
	date string
}

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

func (gc *GCalendar) Parse(srv *calendar.Service) error {
	events, err := gc.getEventsList(srv)
	if err != nil {
		return fmt.Errorf("failed to get events list gcalendar: %w", err)
	}

	if len(events.Items) == 0 {
		fmt.Println("No upcoming events found.")
	} else {
		for _, item := range events.Items {
			gc.date = item.Start.DateTime
			if gc.date == "" {
				gc.date = item.Start.Date
			}
		}
	}
	return nil
}

func (gc *GCalendar) LookForChange(op *operator.IdefixOperator, key, old string) error {
	now := time.Now()
	agendaDate := gc.date

	parse, err := time.Parse(time.RFC3339, agendaDate)
	if err != nil {
		log.Fatalln(err)
	}

	res := parse.Sub(now)
	if res.Minutes() >= 0 && res.Minutes() <= 10 {
		if old == string(rune(NO_ACTIVE)) {
			err := gc.UpdateRedisState(op.RC, key, string(rune(ACTIVE)))
			if err != nil {
				return fmt.Errorf("failed to update redis state: %w", err)
			}

			err = gc.SendToKafka(op.KP, key)
			if err != nil {
				return fmt.Errorf("failed to send message to kafka: %w", err)
			}
		} else if old == string(rune(ACTIVE)) {
			return nil
		}
	} else {
		err := gc.UpdateRedisState(op.RC, key, string(rune(NO_ACTIVE)))
		if err != nil {
			return fmt.Errorf("failed to update redis state: %w", err)
		}
	}
	return nil
}

func (gc *GCalendar) SendToKafka(kp sarama.SyncProducer, workflowID string) error {
	data, err := json.Marshal(Action{workflowID, 1})
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

	if err == redisv8.Nil {
		err = rc.SetKey(key, string(rune(NO_ACTIVE)))
		if err != nil {
			return "", fmt.Errorf("failed to set value in redis: %w", err)
		}

	} else if err != nil {
		return "", fmt.Errorf("failed to get value from redis: %w", err)
	}
	return state, nil
}

func (gc *GCalendar) UpdateRedisState(rc *redis.Client, key, newer string) error {
	err := rc.SetKey(key, newer)
	if err != nil {
		return fmt.Errorf("failed to set key in redis: %w", err)
	}
	return nil
}
