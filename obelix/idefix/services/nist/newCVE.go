package nist

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/kafka"
	"github.com/Shopify/sarama"
	redisv8 "github.com/go-redis/redis/v8"
	"go.uber.org/zap"
	"hash/fnv"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"io"
	"net/http"
	"strconv"
)

type CVE struct {
	Hash string
}

func hash(s string) uint32 {
	h := fnv.New32a()
	if _, err := h.Write([]byte(s)); err != nil {
		return 0
	}

	return h.Sum32()
}

func (c *CVE) Parse() error {
	resp, err := http.Get("https://services.nvd.nist.gov/rest/json/cves/1.0/")
	if err != nil {
		return fmt.Errorf("failed to get request: %w", err)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("failed to read body: %w", err)
	}

	c.Hash = strconv.Itoa(int(hash(string(body))))

	return nil
}

func (c *CVE) GetRedisState(rc *redis.Client, key string) (string, error) {
	state, err := rc.GetKey(key)
	if errors.Is(err, redisv8.Nil) {
		err = rc.SetKey(key, c.Hash)
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

func (c *CVE) LookForChange(op *operator.IdefixOperator, key, old string, owner string) error {
	if old != c.Hash {
		err := c.SendToKafka(op.KP, key, owner)
		if err != nil {
			return fmt.Errorf("failed to send message to task: %w", err)
		}

		err = op.RC.UpdateRedisState(key, c.Hash)
		if err != nil {
			return fmt.Errorf("failed to update value in redis: %w", err)
		}
	}

	return nil
}

func (c *CVE) SendToKafka(kp sarama.SyncProducer, taskID string, owner string) error {
	data, err := json.Marshal(kafka.Message{
		TaskID: taskID,
		Owner:  owner,
	})
	if err != nil {
		return fmt.Errorf("failed to marshal: %w", err)
	}

	msg := producer.PreparePublish("nist", data)

	if _, _, err = kp.SendMessage(msg); err != nil {
		return fmt.Errorf("failed to send message to task: %w", err)
	}

	zap.S().Infof("Message has been sent to Kafka: %s", taskID)

	return nil
}
