/* eslint-disable */
import { Task } from "./task";
import { Empty } from "./google/protobuf/empty";

export const protobufPackage = "area.workflow";

/**
 * ///                /////
 * Workflow definition  //
 * ///                /////
 */
export interface Workflow {
  id: string;
  owner: string;
  name: string;
  tasks: Task[];
}

export interface CreateWorkflowRequest {
  owner: string;
  name: string;
  tasks: Task[];
}

export interface ListWorkflowsRequest {
  owner: string;
}

export interface ListWorkflowsResponse {
  workflows: Workflow[];
}

export interface GetWorkflowRequest {
  id: string;
}

export interface UpdateWorkflowRequest {
  id: string;
  owner?: string | undefined;
  name?: string | undefined;
}

export interface DeleteWorkflowRequest {
  id: string;
}

export interface WorkflowService {
  CreateWorkflow(request: CreateWorkflowRequest): Promise<Workflow>;
  ListWorkflows(request: ListWorkflowsRequest): Promise<ListWorkflowsResponse>;
  GetWorkflow(request: GetWorkflowRequest): Promise<Workflow>;
  UpdateWorkflow(request: UpdateWorkflowRequest): Promise<Workflow>;
  DeleteWorkflow(request: DeleteWorkflowRequest): Promise<Empty>;
}
