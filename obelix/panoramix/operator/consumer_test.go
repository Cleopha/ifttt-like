package operator

import (
	"context"
	"github.com/Cleopha/ifttt-like-common/protos"
	"github.com/PtitLuca/go-dispatcher/dispatcher"
	"github.com/stretchr/testify/assert"
	"math"
	"panoramix/configuration"
	"testing"
)

type mockService struct {
}

func (s *mockService) Method() {

}

func TestCreateNewConsumer(t *testing.T) {
	ctx := context.Background()
	operator, err := New(ctx, &configuration.Configuration{
		GoogleScopes: []string{},
	})

	assert.Error(t, err)
	assert.Nil(t, operator)
}

func TestRunReactionFail(t *testing.T) {
	ctx := context.Background()
	operator := Operator{
		c:   nil,
		d:   dispatcher.New(),
		ctx: ctx,
	}

	err := operator.d.Register("mock", &mockService{})
	assert.NoError(t, err)

	err = operator.runReaction(&protos.Task{
		Action: protos.TaskAction(math.MaxInt32),
	})
	assert.Error(t, err)
}
