package protos

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/protobuf/types/known/emptypb"
	"panoramix/protos/protos"
)

type Action struct {
	TaskID string
}

type Client struct {
	conn *grpc.ClientConn
	clt  __.TaskServiceClient
}

func NewClient(port string) (*Client, error) {
	conn, err := grpc.Dial(":"+port, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to dial: %w", err)
	}

	conn.Connect()
	clt := __.NewTaskServiceClient(conn)

	return &Client{
		conn,
		clt,
	}, nil
}

func (c *Client) CreateTask(ctx context.Context, in *__.CreateTaskRequest, opts ...grpc.CallOption) (*__.Task, error) {
	//TODO implement me
	panic("implement me")
}

// nolint
func (c *Client) ListTasks(ctx context.Context, in *__.ListTasksRequest, opts ...grpc.CallOption) (*__.ListTasksResponse,
	error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) GetTask(ctx context.Context, in *__.GetTaskRequest, opts ...grpc.CallOption) (*__.Task, error) {
	return c.clt.GetTask(ctx, in, opts...)
}

func (c *Client) UpdateTask(ctx context.Context, in *__.UpdateTaskRequest, opts ...grpc.CallOption) (*__.Task, error) {
	//TODO implement me
	panic("implement me")
}

// nolint
func (c *Client) DeleteTask(ctx context.Context, in *__.DeleteTaskRequest, opts ...grpc.CallOption) (*emptypb.Empty, error) {
	//TODO implement me
	panic("implement me")
}
