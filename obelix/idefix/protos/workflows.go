package protos

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/emptypb"
	__ "idefix/protos/protos"
)

type Client struct {
	conn *grpc.ClientConn
	clt  __.WorkflowServiceClient
}

func NewClient(port string) (*Client, error) {
	conn, err := grpc.Dial(":"+port, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to dial: %w", err)
	}

	conn.Connect()
	clt := __.NewWorkflowServiceClient(conn)

	return &Client{
		conn,
		clt,
	}, nil
}

// nolint:lll
func (c *Client) CreateWorkflow(ctx context.Context, in *__.CreateWorkflowRequest, opts ...grpc.CallOption) (*__.Workflow, error) {
	//TODO implement me
	panic("implement me")
}

// nolint:lll
func (c *Client) ListWorkflows(ctx context.Context, in *__.ListWorkflowsRequest, opts ...grpc.CallOption) (*__.ListWorkflowsResponse, error) {
	return c.clt.ListWorkflows(ctx, in, opts...)
}

// nolint:lll
func (c *Client) GetWorkflow(ctx context.Context, in *__.GetWorkflowRequest, opts ...grpc.CallOption) (*__.Workflow, error) {
	//TODO implement me
	panic("implement me")
}

// nolint:lll
func (c *Client) UpdateWorkflow(ctx context.Context, in *__.UpdateWorkflowRequest, opts ...grpc.CallOption) (*__.Workflow, error) {
	//TODO implement me
	panic("implement me")
}

// nolint:lll
func (c *Client) DeleteWorkflow(ctx context.Context, in *__.DeleteWorkflowRequest, opts ...grpc.CallOption) (*emptypb.Empty, error) {
	//TODO implement me
	panic("implement me")
}
