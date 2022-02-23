package services

import (
	"context"
	"fmt"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"go.uber.org/zap"
	"idefix/operator"
	"idefix/producer"
	"idefix/redis"
	"idefix/services/github"
	"idefix/services/google"
)

func RegisterServices(ctx context.Context) (*dispatcher.Dispatcher, error) {
	d := dispatcher.New()
	kp, err := producer.New()

	if err != nil {
		return nil, fmt.Errorf("failed to create task producer: %w", err)
	}

	rc := redis.NewClient(ctx)

	githubClient := &github.Client{
		Requester: nil,
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
	}

	googleClient := &google.Client{
		Requester: nil,
		Scope: []string{
			"https://www.googleapis.com/auth/bigquery",
			"https://www.googleapis.com/auth/blogger",
			"https://www.googleapis.com/auth/calendar",
		},
		Operator: &operator.IdefixOperator{
			RC: rc,
			KP: kp,
		},
	}

	if err = d.Register("github", githubClient); err != nil {
		return nil, fmt.Errorf("failed to register Github services: %w", err)
	}

	if err = d.Register("google", googleClient); err != nil {
		return nil, fmt.Errorf("failed to register Google services: %w", err)
	}

	zap.S().Info("Services are now loaded into idefix")

	return d, nil
}
