package main

import (
	"context"
	"idefix/devAuth"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"idefix/watcher"
	"log"
	"os"
	"strconv"
	"time"
)

var TIME_INTERVAL string

func init() {
	TIME_INTERVAL = os.Getenv("TIME_INTERVAL")
}

func runGithub() {
	kp, err := producer.New()
	if err != nil {
		log.Fatalf("failed to create new producer: %v", err)
	}
	rc := redis.NewClient(context.Background())
	client := devAuth.GithubAuth()

	t, err := strconv.Atoi(TIME_INTERVAL)
	if err != nil {
		log.Fatal(err)
	}

	w := watcher.Watcher{
		Requester: client,
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
		Interval: time.Duration(t) * time.Second,
	}

	err = w.Watch()
	if err != nil {
		log.Fatal(err)
	}
}

func runGCalendar() {
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

	t, err := strconv.Atoi(TIME_INTERVAL)
	if err != nil {
		log.Fatal(err)
	}

	w := watcher.Watcher{
		Requester: client.Clt,
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
		Interval: time.Duration(t) * time.Second,
	}

	err = w.Watch()
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	runGCalendar()
}
