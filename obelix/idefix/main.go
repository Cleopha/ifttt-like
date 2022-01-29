package main

import (
	"context"
	"encoding/json"
	"fmt"
	"idefix/kafka_producer"
	"idefix/redis_management"
	"log"
	"os"
)

// Example for use RedisClient
func example() {
	rclient := redis_management.NewRedisClient(context.Background())

	err := rclient.SetKey("1", "that my boy")
	if err != nil {
		log.Fatal(err)
	}

	key, err := rclient.GetKey("1")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("key: ", key)
}

type Order struct {
	Pizza string `json:"pizza"`
	Table int    `json:"table"`
}

func main() {
	producer, err := kafka_producer.CreateProducer()
	if err != nil {
		fmt.Println("error1", err.Error())
		os.Exit(1)
	}

	pizza, _ := json.Marshal(Order{"margarita", 17})

	msg := kafka_producer.PreparePublish("ntm", pizza)
	p, o, err := producer.SendMessage(msg)
	if err != nil {
		return
	}

	fmt.Println("Partition: ", p)
	fmt.Println("Offset: ", o)

}
