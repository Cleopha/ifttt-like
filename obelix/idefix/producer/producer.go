package producer

import (
	"fmt"
	"github.com/Shopify/sarama"
	"os"
)

var brokers []string

func init() {
	brokers = []string{os.Getenv("PRODUCER_ENDPOINT")}
}

func New() (sarama.SyncProducer, error) {
	config := sarama.NewConfig()
	config.Producer.Partitioner = sarama.NewRandomPartitioner
	config.Producer.RequiredAcks = sarama.WaitForAll
	config.Producer.Return.Successes = true
	producer, err := sarama.NewSyncProducer(brokers, config)

	if err != nil {
		return nil, fmt.Errorf("failed to create sync producer: %v", err)
	}

	return producer, nil
}

func PreparePublish(topic string, data []byte) *sarama.ProducerMessage {
	msg := &sarama.ProducerMessage{
		Topic:     topic,
		Partition: -1,
		Value:     sarama.ByteEncoder(data),
	}

	return msg
}
