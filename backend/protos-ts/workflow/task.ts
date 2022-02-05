/* eslint-disable */
import { GrpcMethod, GrpcStreamMethod } from "@nestjs/microservices";
import { util, configure } from "protobufjs/minimal";
import * as Long from "long";
import { Observable } from "rxjs";
import { Metadata } from "@grpc/grpc-js";
import { Empty } from "./google/protobuf/empty";
import { IsEnum, IsObject, IsOptional, IsString } from 'class-validator';

export const protobufPackage = "area.task";

/** Task kind */
export enum TaskType {
  /** ACTION - Wait for an action */
  ACTION = 0,
  /** REACTION - React to an action */
  REACTION = 1,
  UNRECOGNIZED = -1,
}

/**
 * Available action in the project
 * It will be completed with time
 */
export enum TaskAction {
  /** GITHUB_PR_MERGE - Action */
  GITHUB_PR_MERGE = 0,
  /** GITHUB_ISSUE_CLOSE - Action & reaction */
  GITHUB_ISSUE_CLOSE = 1,
  /** TIMER_DATE - Action */
  TIMER_DATE = 2,
  /** TIMER_INTERVAL - Action */
  TIMER_INTERVAL = 3,
  UNRECOGNIZED = -1,
}

/** Task correspond to an action or reaction */
export interface Task {
  id: string;
  name?: string | undefined;
  type: TaskType;
  action: TaskAction;
  /** Next task to execute (set to "" by default) */
  nextTask: string;
  /** Any additional metadata required to execute the task */
  params: { [key: string]: any } | undefined;
}

export class ListTasksRequest {
  @IsEnum(TaskType)
  @IsOptional()
  filterType?: TaskType | undefined;

  @IsEnum(TaskAction)
  @IsOptional()
  filterAction?: TaskAction | undefined;
}

export interface ListTasksResponse {
  tasks: Task[];
}

export class GetTaskRequest {
  @IsString()
  id: string;
}

export class CreateTaskRequest {
  @IsString()
  workflowId: string;

  @IsString()
  @IsOptional()
  name?: string | undefined;

  @IsEnum(TaskType)
  type: TaskType;

  @IsEnum(TaskAction)
  action: TaskAction;

  @IsString()
  nextTask: string;

  @IsObject()
  params: { [key: string]: any } | undefined;
}

export class UpdateTaskRequest {
  @IsString()
  id: string;

  @IsString()
  @IsOptional()
  name?: string | undefined;

  @IsEnum(TaskType)
  @IsOptional()
  type?: TaskType | undefined;

  @IsEnum(TaskAction)
  @IsOptional()
  action?: TaskAction | undefined;

  @IsOptional()
  @IsString()
  nextTask?: string | undefined;

  @IsOptional()
  params?: { [key: string]: any } | undefined;
}

export class DeleteTaskRequest {
  @IsString()
  id: string;
}

export const AREA_TASK_PACKAGE_NAME = "area.task";

/** CRUD operation to manipulate a Task */

export interface TaskServiceClient {
  createTask(request: CreateTaskRequest, metadata?: Metadata): Observable<Task>;

  listTasks(
    request: ListTasksRequest,
    metadata?: Metadata
  ): Observable<ListTasksResponse>;

  getTask(request: GetTaskRequest, metadata?: Metadata): Observable<Task>;

  updateTask(request: UpdateTaskRequest, metadata?: Metadata): Observable<Task>;

  deleteTask(
    request: DeleteTaskRequest,
    metadata?: Metadata
  ): Observable<Empty>;
}

/** CRUD operation to manipulate a Task */

export interface TaskServiceController {
  createTask(
    request: CreateTaskRequest,
    metadata?: Metadata
  ): Promise<Task> | Observable<Task> | Task;

  listTasks(
    request: ListTasksRequest,
    metadata?: Metadata
  ):
    | Promise<ListTasksResponse>
    | Observable<ListTasksResponse>
    | ListTasksResponse;

  getTask(
    request: GetTaskRequest,
    metadata?: Metadata
  ): Promise<Task> | Observable<Task> | Task;

  updateTask(
    request: UpdateTaskRequest,
    metadata?: Metadata
  ): Promise<Task> | Observable<Task> | Task;

  deleteTask(request: DeleteTaskRequest, metadata?: Metadata): void;
}

export function TaskServiceControllerMethods() {
  return function (constructor: Function) {
    const grpcMethods: string[] = [
      "createTask",
      "listTasks",
      "getTask",
      "updateTask",
      "deleteTask",
    ];
    for (const method of grpcMethods) {
      const descriptor: any = Reflect.getOwnPropertyDescriptor(
        constructor.prototype,
        method
      );
      GrpcMethod("TaskService", method)(
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
      GrpcStreamMethod("TaskService", method)(
        constructor.prototype[method],
        method,
        descriptor
      );
    }
  };
}

export const TASK_SERVICE_NAME = "TaskService";

// If you get a compile-error about 'Constructor<Long> and ... have no overlap',
// add '--ts_proto_opt=esModuleInterop=true' as a flag when calling 'protoc'.
if (util.Long !== Long) {
  util.Long = Long as any;
  configure();
}
