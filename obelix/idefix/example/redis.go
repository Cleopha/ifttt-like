package example

import (
	"context"
	"fmt"
	"idefix/redis"
	"log"
)

// Example for use RedisClient
func exampleRedis() {
	rclient := redis.NewClient(context.Background())

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
