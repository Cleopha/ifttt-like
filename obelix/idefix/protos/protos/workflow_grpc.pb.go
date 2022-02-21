// Code generated by protoc-gen-go-grpc. DO NOT EDIT.

package __

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
	emptypb "google.golang.org/protobuf/types/known/emptypb"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// WorkflowServiceClient is the client API for WorkflowService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type WorkflowServiceClient interface {
	CreateWorkflow(ctx context.Context, in *CreateWorkflowRequest, opts ...grpc.CallOption) (*Workflow, error)
	ListWorkflows(ctx context.Context, in *ListWorkflowsRequest, opts ...grpc.CallOption) (*ListWorkflowsResponse, error)
	GetWorkflow(ctx context.Context, in *GetWorkflowRequest, opts ...grpc.CallOption) (*Workflow, error)
	UpdateWorkflow(ctx context.Context, in *UpdateWorkflowRequest, opts ...grpc.CallOption) (*Workflow, error)
	DeleteWorkflow(ctx context.Context, in *DeleteWorkflowRequest, opts ...grpc.CallOption) (*emptypb.Empty, error)
}

type workflowServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewWorkflowServiceClient(cc grpc.ClientConnInterface) WorkflowServiceClient {
	return &workflowServiceClient{cc}
}

func (c *workflowServiceClient) CreateWorkflow(ctx context.Context, in *CreateWorkflowRequest, opts ...grpc.CallOption) (*Workflow, error) {
	out := new(Workflow)
	err := c.cc.Invoke(ctx, "/area.workflow.WorkflowService/CreateWorkflow", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *workflowServiceClient) ListWorkflows(ctx context.Context, in *ListWorkflowsRequest, opts ...grpc.CallOption) (*ListWorkflowsResponse, error) {
	out := new(ListWorkflowsResponse)
	err := c.cc.Invoke(ctx, "/area.workflow.WorkflowService/ListWorkflows", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *workflowServiceClient) GetWorkflow(ctx context.Context, in *GetWorkflowRequest, opts ...grpc.CallOption) (*Workflow, error) {
	out := new(Workflow)
	err := c.cc.Invoke(ctx, "/area.workflow.WorkflowService/GetWorkflow", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *workflowServiceClient) UpdateWorkflow(ctx context.Context, in *UpdateWorkflowRequest, opts ...grpc.CallOption) (*Workflow, error) {
	out := new(Workflow)
	err := c.cc.Invoke(ctx, "/area.workflow.WorkflowService/UpdateWorkflow", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *workflowServiceClient) DeleteWorkflow(ctx context.Context, in *DeleteWorkflowRequest, opts ...grpc.CallOption) (*emptypb.Empty, error) {
	out := new(emptypb.Empty)
	err := c.cc.Invoke(ctx, "/area.workflow.WorkflowService/DeleteWorkflow", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// WorkflowServiceServer is the server API for WorkflowService service.
// All implementations must embed UnimplementedWorkflowServiceServer
// for forward compatibility
type WorkflowServiceServer interface {
	CreateWorkflow(context.Context, *CreateWorkflowRequest) (*Workflow, error)
	ListWorkflows(context.Context, *ListWorkflowsRequest) (*ListWorkflowsResponse, error)
	GetWorkflow(context.Context, *GetWorkflowRequest) (*Workflow, error)
	UpdateWorkflow(context.Context, *UpdateWorkflowRequest) (*Workflow, error)
	DeleteWorkflow(context.Context, *DeleteWorkflowRequest) (*emptypb.Empty, error)
	mustEmbedUnimplementedWorkflowServiceServer()
}

// UnimplementedWorkflowServiceServer must be embedded to have forward compatible implementations.
type UnimplementedWorkflowServiceServer struct {
}

func (UnimplementedWorkflowServiceServer) CreateWorkflow(context.Context, *CreateWorkflowRequest) (*Workflow, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CreateWorkflow not implemented")
}
func (UnimplementedWorkflowServiceServer) ListWorkflows(context.Context, *ListWorkflowsRequest) (*ListWorkflowsResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method ListWorkflows not implemented")
}
func (UnimplementedWorkflowServiceServer) GetWorkflow(context.Context, *GetWorkflowRequest) (*Workflow, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetWorkflow not implemented")
}
func (UnimplementedWorkflowServiceServer) UpdateWorkflow(context.Context, *UpdateWorkflowRequest) (*Workflow, error) {
	return nil, status.Errorf(codes.Unimplemented, "method UpdateWorkflow not implemented")
}
func (UnimplementedWorkflowServiceServer) DeleteWorkflow(context.Context, *DeleteWorkflowRequest) (*emptypb.Empty, error) {
	return nil, status.Errorf(codes.Unimplemented, "method DeleteWorkflow not implemented")
}
func (UnimplementedWorkflowServiceServer) mustEmbedUnimplementedWorkflowServiceServer() {}

// UnsafeWorkflowServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to WorkflowServiceServer will
// result in compilation errors.
type UnsafeWorkflowServiceServer interface {
	mustEmbedUnimplementedWorkflowServiceServer()
}

func RegisterWorkflowServiceServer(s grpc.ServiceRegistrar, srv WorkflowServiceServer) {
	s.RegisterService(&WorkflowService_ServiceDesc, srv)
}

func _WorkflowService_CreateWorkflow_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CreateWorkflowRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(WorkflowServiceServer).CreateWorkflow(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/area.workflow.WorkflowService/CreateWorkflow",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(WorkflowServiceServer).CreateWorkflow(ctx, req.(*CreateWorkflowRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _WorkflowService_ListWorkflows_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(ListWorkflowsRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(WorkflowServiceServer).ListWorkflows(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/area.workflow.WorkflowService/ListWorkflows",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(WorkflowServiceServer).ListWorkflows(ctx, req.(*ListWorkflowsRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _WorkflowService_GetWorkflow_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(GetWorkflowRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(WorkflowServiceServer).GetWorkflow(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/area.workflow.WorkflowService/GetWorkflow",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(WorkflowServiceServer).GetWorkflow(ctx, req.(*GetWorkflowRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _WorkflowService_UpdateWorkflow_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(UpdateWorkflowRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(WorkflowServiceServer).UpdateWorkflow(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/area.workflow.WorkflowService/UpdateWorkflow",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(WorkflowServiceServer).UpdateWorkflow(ctx, req.(*UpdateWorkflowRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _WorkflowService_DeleteWorkflow_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(DeleteWorkflowRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(WorkflowServiceServer).DeleteWorkflow(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/area.workflow.WorkflowService/DeleteWorkflow",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(WorkflowServiceServer).DeleteWorkflow(ctx, req.(*DeleteWorkflowRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// WorkflowService_ServiceDesc is the grpc.ServiceDesc for WorkflowService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var WorkflowService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "area.workflow.WorkflowService",
	HandlerType: (*WorkflowServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "CreateWorkflow",
			Handler:    _WorkflowService_CreateWorkflow_Handler,
		},
		{
			MethodName: "ListWorkflows",
			Handler:    _WorkflowService_ListWorkflows_Handler,
		},
		{
			MethodName: "GetWorkflow",
			Handler:    _WorkflowService_GetWorkflow_Handler,
		},
		{
			MethodName: "UpdateWorkflow",
			Handler:    _WorkflowService_UpdateWorkflow_Handler,
		},
		{
			MethodName: "DeleteWorkflow",
			Handler:    _WorkflowService_DeleteWorkflow_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "workflow.proto",
}
