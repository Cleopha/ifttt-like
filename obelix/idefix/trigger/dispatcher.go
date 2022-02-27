package trigger

import (
	"github.com/Shopify/sarama"
	"idefix/operator"
	"idefix/redis"
)

/*
** Used for the implementation of new services for which we want the event trigger
 */

type Dispatcher interface {
	Parse(data interface{}) error
	LookForChange(op *operator.IdefixOperator, key, old string, owner string) error
	SendToKafka(kp sarama.SyncProducer, taskID, owner string) error
	GetRedisState(rc *redis.Client, key string) (string, error)
}
