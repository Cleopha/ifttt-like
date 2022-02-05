package trigger

import (
	"github.com/Shopify/sarama"
	"idefix/operator"
	"idefix/redis"
	"reflect"
)

type Dispatcher interface {
	Parse(data []byte) (reflect.Value, error)
	LookForChange(op *operator.IdefixOperator, key, old string) error
	SendToKafka(kp sarama.SyncProducer, workflowID string) error
	GetRedisState(rc *redis.Client, key string) (string, error)
	UpdateRedisState(rc *redis.Client, key, newer string) error
}
