package main

import (
	"fmt"
	"idefix/redis_management"
	"log"
)

// Example for use RedisClient
func example() {
	rclient := redis_management.NewRedisClient()

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

func main() {
	example()
}
