/* eslint-disable */
import { GrpcMethod, GrpcStreamMethod } from "@nestjs/microservices";
import { util, configure } from "protobufjs/minimal";
import * as Long from "long";
import { Observable } from "rxjs";
import { Task } from "./task";
import { Metadata } from "@grpc/grpc-js";
import { Empty } from "./google/protobuf/empty";
import { IsOptional, IsString } from 'class-validator';

export const protobufPackage = "area.workflow";

/** A workflow is a set of task (action and reaction) to execute */
export interface Workflow {
  id: string;
  owner: string;
  name: string;
  tasks: Task[];
}

export class CreateWorkflowRequest {
  @IsString()
  owner: string;

  @IsString()
  name: string;

  tasks: Task[];
}

export class ListWorkflowsRequest {
  @IsString()
  owner: string;
}

export interface ListWorkflowsResponse {
  workflows: Workflow[];
}

export class GetWorkflowRequest {
  @IsString()
  id: string;
}

export class UpdateWorkflowRequest {
  @IsString()
  id: string;

  @IsString()
  @IsOptional()
  owner?: string | undefined;

  @IsString()
  @IsOptional()
  name?: string | undefined;
}

export class DeleteWorkflowRequest {
  @IsString()
  id: string;
}

export const AREA_WORKFLOW_PACKAGE_NAME = "area.workflow";

/** CRUD operation to manipulate a Workflow */

export interface WorkflowServiceClient {
  createWorkflow(
    request: CreateWorkflowRequest,
    metadata?: Metadata
  ): Observable<Workflow>;

  listWorkflows(
    request: ListWorkflowsRequest,
    metadata?: Metadata
  ): Observable<ListWorkflowsResponse>;

  getWorkflow(
    request: GetWorkflowRequest,
    metadata?: Metadata
  ): Observable<Workflow>;

  updateWorkflow(
    request: UpdateWorkflowRequest,
    metadata?: Metadata
  ): Observable<Workflow>;

  deleteWorkflow(
    request: DeleteWorkflowRequest,
    metadata?: Metadata
  ): Observable<Empty>;
}

/** CRUD operation to manipulate a Workflow */

export interface WorkflowServiceController {
  createWorkflow(
    request: CreateWorkflowRequest,
    metadata?: Metadata
  ): Promise<Workflow> | Observable<Workflow> | Workflow;

  listWorkflows(
    request: ListWorkflowsRequest,
    metadata?: Metadata
  ):
    | Promise<ListWorkflowsResponse>
    | Observable<ListWorkflowsResponse>
    | ListWorkflowsResponse;

  getWorkflow(
    request: GetWorkflowRequest,
    metadata?: Metadata
  ): Promise<Workflow> | Observable<Workflow> | Workflow;

  updateWorkflow(
    request: UpdateWorkflowRequest,
    metadata?: Metadata
  ): Promise<Workflow> | Observable<Workflow> | Workflow;

  deleteWorkflow(request: DeleteWorkflowRequest, metadata?: Metadata): void;
}

export function WorkflowServiceControllerMethods() {
  return function (constructor: Function) {
    const grpcMethods: string[] = [
      "createWorkflow",
      "listWorkflows",
      "getWorkflow",
      "updateWorkflow",
      "deleteWorkflow",
    ];
    for (const method of grpcMethods) {
      const descriptor: any = Reflect.getOwnPropertyDescriptor(
        constructor.prototype,
        method
      );
      GrpcMethod("WorkflowService", method)(
        constructor.prototype[method],
        method,
        descriptor
      );
    }
    const grpcStreamMethods: string[] = [];
    for (const method of grpcStreamMethods) {
      const descriptor: any = Reflect.getOwnPropertyDescriptor(
        constructor.prototype,
        method
      );
      GrpcStreamMethod("WorkflowService", method)(
        constructor.prototype[method],
        method,
        descriptor
      );
    }
  };
}

export const WORKFLOW_SERVICE_NAME = "WorkflowService";

// If you get a compile-error about 'Constructor<Long> and ... have no overlap',
// add '--ts_proto_opt=esModuleInterop=true' as a flag when calling 'protoc'.
if (util.Long !== Long) {
  util.Long = Long as any;
  configure();
}
