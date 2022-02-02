/* eslint-disable */
import { Empty } from "./google/protobuf/empty";
import { Observable } from 'rxjs';

export const protobufPackage = "area.task";

/** Task kind */
export enum TaskType {
  ACTION = 0,
  REACTION = 1,
  UNRECOGNIZED = -1,
}

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

/**
 * ///            /////
 * Task definition  //
 * ///            /////
 */
export interface Task {
  id: string;
  name?: string | undefined;
  type: TaskType;
  action: TaskAction;
  nextTask: string;
  params: { [key: string]: any } | undefined;
}

export interface ListTasksRequest {
  filerType?: TaskType | undefined;
  filerAction?: TaskAction | undefined;
}

export interface ListTasksResponse {
  tasks: Task[];
}

export interface GetTaskRequest {
  id: string;
}

export interface CreateTaskRequest {
  workflowId: string;
  name?: string | undefined;
  type: TaskType;
  action: TaskAction;
  nextTask: string;
  params: { [key: string]: any } | undefined;
}

export interface UpdateTaskRequest {
  id: string;
  name?: string | undefined;
  type?: TaskType | undefined;
  action?: TaskAction | undefined;
  nextTask?: string | undefined;
  params?: { [key: string]: any } | undefined;
}

export interface DeleteTaskRequest {
  id: string;
}

export interface TaskService {
  CreateTask(request: CreateTaskRequest): Observable<Task>;
  ListTasks(request: ListTasksRequest): Observable<ListTasksResponse>;
  GetTask(request: GetTaskRequest): Observable<Task>;
  UpdateTask(request: UpdateTaskRequest): Observable<Task>;
  DeleteTask(request: DeleteTaskRequest): Observable<Empty>;
}
