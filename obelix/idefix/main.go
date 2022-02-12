package main

import (
	"context"
	"idefix/devAuth"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"idefix/watcher"
	"log"
	"time"
)

func runGithub() {
	kp, err := producer.New()
	if err != nil {
		log.Fatalf("failed to create new producer: %v", err)
	}
	rc := redis.NewClient(context.Background())
	client := devAuth.GithubAuth()

	w := watcher.Watcher{
		Requester: client,
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
		Interval: 2 * time.Second,
	}

	err = w.Watch()
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	kp, err := producer.New()
	if err != nil {
		log.Fatalf("failed to create new producer: %v", err)
	}
	rc := redis.NewClient(context.Background())
	client, err := devAuth.New(context.Background(), []string{
		"https://www.googleapis.com/auth/bigquery",
		"https://www.googleapis.com/auth/blogger",
		"https://www.googleapis.com/auth/calendar",
	})

	w := watcher.Watcher{
		Requester: client.Clt,
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
		Interval: 2 * time.Second,
	}

	err = w.Watch()
	if err != nil {
		log.Fatal(err)
	}
}
