package services

import (
	"context"
	"github.com/stretchr/testify/assert"
	"panoramix/configuration"
	"testing"
)

func TestRegisterServices(t *testing.T) {
	ctx := context.Background()
	dispatcher, err := RegisterServices(ctx, &configuration.Configuration{
		GoogleScopes: []string{},
	})

	assert.NoError(t, err)
	assert.NotNil(t, dispatcher)
}
