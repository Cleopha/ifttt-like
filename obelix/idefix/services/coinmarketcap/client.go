package coinmarketcap

import (
	"context"
	"fmt"
	"google.golang.org/protobuf/types/known/structpb"
	"idefix/operator"
)

type Client struct {
	ctx      context.Context
	Operator *operator.IdefixOperator
}

type params struct {
	limit float32
}

func NewClient(ctx context.Context, op *operator.IdefixOperator) *Client {
	return &Client{
		ctx:      ctx,
		Operator: op,
	}
}

// parseParams get params of gRPC
func (c *Client) parseParams(prm *structpb.Struct) *params {
	return &params{
		limit: float32(prm.Fields["user"].GetNumberValue()),
	}
}

func (c *Client) AssetVariationDetected(taskID string, prm *structpb.Struct, owner string) error {
	var dominance Dominance

	p := c.parseParams(prm)

	if err := dominance.Parse(); err != nil {
		return fmt.Errorf("failed to parse body: %w", err)
	}

	old, err := dominance.GetRedisState(c.Operator.RC, taskID)
	if err != nil {
		return fmt.Errorf("failed to update redis state: %w", err)
	}

	err = dominance.LookForChange(c.Operator, taskID, old, owner, p.limit)
	if err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}
