package workflow

import (
	"context"
	"fmt"
	"github.com/Cleopha/ifttt-like-common/protos"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Client struct {
	conn *grpc.ClientConn
	clt  protos.WorkflowServiceClient
}

func NewClient(port string) (*Client, error) {
	conn, err := grpc.Dial(":"+port, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to dial: %w", err)
	}

	conn.Connect()
	clt := protos.NewWorkflowServiceClient(conn)

	return &Client{
		conn,
		clt,
	}, nil
}

func (c *Client) CreateWorkflow(ctx context.Context, in *protos.CreateWorkflowRequest,
	opts ...grpc.CallOption) (*protos.Workflow, error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) ListWorkflows(ctx context.Context, in *protos.ListWorkflowsRequest,
	opts ...grpc.CallOption) (*protos.ListWorkflowsResponse, error) {
	return c.clt.ListWorkflows(ctx, in, opts...)
}

//nolint:lll
func (c *Client) GetWorkflow(ctx context.Context, in *protos.GetWorkflowRequest, opts ...grpc.CallOption) (*protos.Workflow,
	error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) UpdateWorkflow(ctx context.Context, in *protos.UpdateWorkflowRequest,
	opts ...grpc.CallOption) (*protos.Workflow, error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) DeleteWorkflow(ctx context.Context, in *protos.DeleteWorkflowRequest,
	opts ...grpc.CallOption) (*emptypb.Empty, error) {
	//TODO implement me
	panic("implement me")
}
