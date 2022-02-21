package services

import (
	"context"
	"fmt"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"idefix/services/github"
)

func RegisterServices(ctx context.Context) (*dispatcher.Dispatcher, error) {
	d := dispatcher.New()
	kp, err := producer.New()

	if err != nil {
		return nil, fmt.Errorf("failed to create kafka producer: %w", err)
	}

	rc := redis.NewClient(ctx)

	githubClient := &github.Client{
		Requester: nil,
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
	}

	if err := d.Register("github", githubClient); err != nil {
		return nil, fmt.Errorf("failed to register Github services: %w", err)
	}

	return d, nil
}
