package nist

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

func NewClient(ctx context.Context, op *operator.IdefixOperator) *Client {
	return &Client{
		ctx:      ctx,
		Operator: op,
	}
}

func (c *Client) NewCveDetected(taskID string, prm *structpb.Struct, owner string) error {
	var cve CVE

	// Extract hash of new cve
	if err := cve.Parse(); err != nil {
		return fmt.Errorf("failed to parse new cve data: %w", err)
	}

	// Retrieves the last state from the Redis DB.
	old, err := cve.GetRedisState(c.Operator.RC, taskID)
	if err != nil {
		return fmt.Errorf("failed to update redis state: %w", err)
	}

	// Verifies if the event is in the range of < 10 minutes.
	if err = cve.LookForChange(c.Operator, taskID, old, owner); err != nil {
		return fmt.Errorf("an error has occurred while looking for changes: %w", err)
	}

	return nil
}
