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

func (gc *GCalendar) Parse(srv *calendar.Service) error {
	t := time.Now().Format(time.RFC3339)
	events, err := srv.Events.List("primary").ShowDeleted(false).SingleEvents(true).TimeMin(t).MaxResults(1).OrderBy("startTime").Do()
	if err != nil {
		return fmt.Errorf("failed to retrieve next event gcalendar: %v", err)
	}

	if len(events.Items) == 0 {
		fmt.Println("No upcoming events found.")
	} else {
		for _, item := range events.Items {
			gc.date = item.Start.DateTime
			if gc.date == "" {
				gc.date = item.Start.Date
			}
			fmt.Printf("%v (%v)\n", item.Summary, gc.date)
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
	if (res.Minutes() >= 0 && res.Minutes() <= 10) && (old == string(rune(NO_ACTIVE))) {
		err := gc.UpdateRedisState(op.RC, key, string(rune(ACTIVE)))
		if err != nil {
			return fmt.Errorf("failed to update redis state: %v", err)
		}

		err = gc.SendToKafka(op.KP, key)
		if err != nil {
			return fmt.Errorf("failed to send message to kafka: %v", err)
		}
		fmt.Println("Nice send kafka")
	} else if (res.Minutes() >= 0 && res.Minutes() <= 10) && (old == string(rune(ACTIVE))) {
		return nil
	} else {
		err := gc.UpdateRedisState(op.RC, key, string(rune(NO_ACTIVE)))
		if err != nil {
			return fmt.Errorf("failed to update redis state: %v", err)
		}
	}
	return nil
}

func (gc *GCalendar) SendToKafka(kp sarama.SyncProducer, workflowID string) error {
	data, err := json.Marshal(Action{workflowID, 1})
	if err != nil {
		return fmt.Errorf("failed to marshal: %v", err)
	}

	msg := producer.PreparePublish("google", data)

	_, _, err = kp.SendMessage(msg)
	if err != nil {
		return fmt.Errorf("failed to send message to kafka: %v", err)
	}
	return nil
}

func (gc *GCalendar) GetRedisState(rc *redis.Client, key string) (string, error) {
	state, err := rc.GetKey(key)

	if err == redisv8.Nil {

		err = rc.SetKey(key, string(rune(NO_ACTIVE)))
		if err != nil {
			return "", fmt.Errorf("failed to set value in redis: %v", err)
		}
		fmt.Println("Create value in redis: ", gc.date)

	} else if err != nil {
		return "", fmt.Errorf("failed to get value from redis: %v", err)
	}
	return state, nil
}

func (gc *GCalendar) UpdateRedisState(rc *redis.Client, key, newer string) error {
	err := rc.SetKey(key, newer)
	if err != nil {
		return fmt.Errorf("failed to set key in redis: %v", err)
	}
	return nil
}
