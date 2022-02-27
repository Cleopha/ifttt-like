package operator

import (
	"github.com/Shopify/sarama"
	"idefix/redis"
)

type IdefixOperator struct {
	RC *redis.Client
	KP sarama.SyncProducer
}
