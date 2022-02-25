package main

import (
	"context"
	"github.com/Cleopha/ifttt-like-common/logger"
	"go.uber.org/zap"
	"idefix/watcher"
	"log"
)

/*
func runGCalendar() {
	kp, err := producer.New()
	if err != nil {
		log.Fatalf("failed to create new producer: %v", err)
	}

	rc := redis.NewClient(context.Background())

	client, err := devauth.New(context.Background(), []string{
		"https://www.googleapis.com/auth/bigquery",
		"https://www.googleapis.com/auth/blogger",
		"https://www.googleapis.com/auth/calendar",
	})

	if err != nil {
		log.Fatal(err)
	}

	t, err := strconv.Atoi(TimeInterval)
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
*/

func main() {
	if err := logger.InitLogger("logs", "idefix_logs.txt", logger.Dev); err != nil {
		log.Fatalln(err)
	}

	ctx := context.Background()
	w, err := watcher.New(ctx)

	if err != nil {
		zap.S().Fatal(err)
	}

	if err := w.Watch(); err != nil {
		zap.S().Fatal(err)
	}
}
