package services

import (
	"context"
	"fmt"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"panoramix/configuration"
	"panoramix/services/google"
)

func RegisterServices(ctx context.Context, conf *configuration.Configuration) (*dispatcher.Dispatcher, error) {
	d := dispatcher.New()

	googleClient, err := google.New(ctx, conf.GoogleScopes)
	if err != nil {
		return nil, fmt.Errorf("failed to create google client: %w", err)
	}

	if err := d.Register("google", googleClient); err != nil {
		return nil, fmt.Errorf("failed to register Google service: %w", err)
	}
	return d, nil
}
