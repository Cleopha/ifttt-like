package github

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/kafka"
	"github.com/Shopify/sarama"
	redisv8 "github.com/go-redis/redis/v8"
	"go.uber.org/zap"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
)

var ErrNoIssues = fmt.Errorf("no issues in the repository")

type Issues struct {
	Issues []Issue `json:"issues,omitempty"`
}

type Issue struct {
	ID            int         `json:"id"`
	NodeID        string      `json:"node_id"`
	URL           string      `json:"url"`
	RepositoryURL string      `json:"repository_url"`
	PullRequest   interface{} `json:"pull_request,omitempty"`
}

func (i *Issues) Parse(data []byte) error {
	err := json.Unmarshal(data, &i.Issues)
	if err != nil {
		return fmt.Errorf("failed to Unmarshal %w", err)
	}

	return nil
}

func (i *Issues) findLatestIssue(isPR bool) (*Issue, bool) {
	for _, elem := range i.Issues {
		if !isPR && elem.PullRequest == nil {
			return &elem, true
		} else if isPR && elem.PullRequest != nil {
			return &elem, true
		}
	}

	return nil, false
}

func (i *Issues) GetRedisState(rc *redis.Client, key string, isPR bool) (string, error) {
	state, err := rc.GetKey(key)
	if errors.Is(err, redisv8.Nil) {
		elem, ok := i.findLatestIssue(isPR)
		if !ok {
			return "", ErrNoIssues
		}

		err = rc.SetKey(key, elem.URL)
		if err != nil {
			return "", fmt.Errorf("failed to set value in redis: %w", err)
		}

		return "", redis.ErrFirstRedisLookup
	}

	if err != nil {
		return "", fmt.Errorf("failed to get value from redis: %w", err)
	}

	return state, nil
}

func (i *Issues) LookForChange(op *operator.IdefixOperator, key, old string, isPR bool, owner string) error {
	newer, ok := i.findLatestIssue(isPR)
	if !ok {
		return ErrNoIssues
	}

	if old != newer.URL {
		err := i.SendToKafka(op.KP, key, owner)
		if err != nil {
			return fmt.Errorf("failed to send message to task: %w", err)
		}

		err = op.RC.UpdateRedisState(key, newer.URL)
		if err != nil {
			return fmt.Errorf("failed to update value in redis: %w", err)
		}
	}

	return nil
}

func (i *Issues) SendToKafka(kp sarama.SyncProducer, taskID string, owner string) error {
	data, err := json.Marshal(kafka.Message{
		TaskID: taskID,
		Owner:  owner,
	})
	if err != nil {
		return fmt.Errorf("failed to marshal: %w", err)
	}

	msg := producer.PreparePublish("github", data)

	if _, _, err = kp.SendMessage(msg); err != nil {
		return fmt.Errorf("failed to send message to task: %w", err)
	}

	zap.S().Infof("Message has been sent to Kafka: %s", taskID)

	return nil
}
