package coinmarketcap

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/kafka"
	"github.com/Shopify/sarama"
	redisv8 "github.com/go-redis/redis/v8"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

const (
	Active   = "active"
	Inactive = "inactive"
)

var (
	ClientID = ""
)

func init() {
	ClientID = os.Getenv("COINMARKETCAP_CLIENT_ID")

	if ClientID == "" {
		log.Fatal(errors.New("github credentials are not set"))
	}
}

type data struct {
	BtcDominance float32 `json:"btc_dominance"`
	EthDominance float32 `json:"eth_dominance"`
}

type Dominance struct {
	Data data `json:"data"`
}

func (d *Dominance) Parse() error {
	client := &http.Client{}
	req, err := http.NewRequest("GET", "https://pro-api.coinmarketcap.com/v1/global-metrics/quotes/latest", nil)

	if err != nil {
		return fmt.Errorf("failed to create new request: %w", err)
	}

	req.Header.Set("Accepts", "application/json")
	req.Header.Add("X-CMC_PRO_API_KEY", ClientID)

	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("failed tp send request: %w", err)
	}

	respBody, _ := ioutil.ReadAll(resp.Body)

	if err = json.Unmarshal(respBody, d); err != nil {
		return fmt.Errorf("failed to unmarshal dominance data: %w", err)
	}

	return nil
}

func (d *Dominance) LookForChange(op *operator.IdefixOperator, key, old, owner string, limit float32) error {
	// If the number of volumes exceeds limit, trigger the action.
	if d.Data.BtcDominance > limit {
		// We only trigger the action if it was not previously triggered.
		if old == Inactive {
			if err := op.RC.UpdateRedisState(key, Active); err != nil {
				return fmt.Errorf("failed to update Redis state: %w", err)
			}

			if err := d.SendToKafka(op.KP, key, owner); err != nil {
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

func (d *Dominance) GetRedisState(rc *redis.Client, key string) (string, error) {
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

func (d *Dominance) SendToKafka(kp sarama.SyncProducer, taskID, owner string) error {
	data, err := json.Marshal(kafka.Message{
		TaskID: taskID,
		Owner:  owner,
	})
	if err != nil {
		return fmt.Errorf("failed to marshal: %w", err)
	}

	msg := producer.PreparePublish("coinmarketcap", data)

	_, _, err = kp.SendMessage(msg)
	if err != nil {
		return fmt.Errorf("failed to send message to kafka: %w", err)
	}

	return nil
}
