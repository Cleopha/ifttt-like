package task

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
	clt  protos.TaskServiceClient
}

func NewClient(port string) (*Client, error) {
	conn, err := grpc.Dial(":"+port, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to dial: %w", err)
	}

	conn.Connect()
	clt := protos.NewTaskServiceClient(conn)

	return &Client{
		conn,
		clt,
	}, nil
}

func (c *Client) Shutdown() error {
	return c.conn.Close()
}

func (c *Client) CreateTask(ctx context.Context, in *protos.CreateTaskRequest,
	opts ...grpc.CallOption) (*protos.Task,
	error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) ListTasks(ctx context.Context, in *protos.ListTasksRequest,
	opts ...grpc.CallOption) (*protos.ListTasksResponse,
	error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) GetTask(ctx context.Context, in *protos.GetTaskRequest, opts ...grpc.CallOption) (*protos.Task,
	error) {
	return c.clt.GetTask(ctx, in, opts...)
}

func (c *Client) UpdateTask(ctx context.Context, in *protos.UpdateTaskRequest,
	opts ...grpc.CallOption) (*protos.Task,
	error) {
	//TODO implement me
	panic("implement me")
}

func (c *Client) DeleteTask(ctx context.Context, in *protos.DeleteTaskRequest,
	opts ...grpc.CallOption) (*emptypb.Empty,
	error) {
	//TODO implement me
	panic("implement me")
}
