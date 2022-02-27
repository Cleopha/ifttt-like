package scaleway

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/kafka"
	"github.com/Shopify/sarama"
	redisv8 "github.com/go-redis/redis/v8"
	"github.com/scaleway/scaleway-sdk-go/api/instance/v1"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
)

var (
	ErrInvalidVolumeConversion = errors.New("failed to convert volume")
)

const (
	Active   = "active"
	Inactive = "inactive"
)

type Volume struct {
	Limit    uint32
	elements *instance.ListVolumesResponse
}

func (v *Volume) Parse(data interface{}) error {
	volumes, ok := data.(*instance.ListVolumesResponse)
	if !ok {
		return ErrInvalidVolumeConversion
	}

	v.elements = volumes

	return nil
}

func (v *Volume) LookForChange(op *operator.IdefixOperator, key, old, owner string) error {
	// If the number of volumes exceeds limit, trigger the action.
	if v.elements.TotalCount > v.Limit {
		// We only trigger the action if it was not previously triggered.
		if old == Inactive {
			if err := op.RC.UpdateRedisState(key, Active); err != nil {
				return fmt.Errorf("failed to update Redis state: %w", err)
			}

			if err := v.SendToKafka(op.KP, key, owner); err != nil {
				return fmt.Errorf("failed to send message to Kafka: %w", err)
			}
		} else if old == Active {
			return nil
		}
	} else {
		if err := op.RC.UpdateRedisState(key, Inactive); err != nil {
			return fmt.Errorf("failed to update Redis state: %w", err)
		}
	}

	return nil
}

func (v *Volume) GetRedisState(rc *redis.Client, key string) (string, error) {
	state, err := rc.GetKey(key)
	if errors.Is(err, redisv8.Nil) {
		if err = rc.SetKey(key, Inactive); err != nil {
			return "", fmt.Errorf("failed to set value in redis: %w", err)
		}

		state = Inactive
	} else if err != nil {
		return "", fmt.Errorf("failed to get value from redis: %w", err)
	}

	return state, nil
}

func (v *Volume) SendToKafka(kp sarama.SyncProducer, taskID, owner string) error {
	data, err := json.Marshal(kafka.Message{
		TaskID: taskID,
		Owner:  owner,
	})
	if err != nil {
		return fmt.Errorf("failed to marshal: %w", err)
	}

	msg := producer.PreparePublish("scaleway", data)

	_, _, err = kp.SendMessage(msg)
	if err != nil {
		return fmt.Errorf("failed to send message to kafka: %w", err)
	}

	return nil
}
