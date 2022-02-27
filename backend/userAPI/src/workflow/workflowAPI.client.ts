import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientGrpc } from '@nestjs/microservices';

import {
	CreateWorkflowRequest,
	DeleteWorkflowRequest, Empty,
	GetWorkflowRequest,
	ListWorkflowsRequest,
	UpdateWorkflowRequest,
	Workflow,
	WorkflowServiceClient
} from '@protos';
import { Convertor } from '@util/convertor';

@Injectable()
export class WorkflowAPIClient implements OnModuleInit {
	private workflowService: WorkflowServiceClient;

	constructor(@Inject('WORKFLOW_PACKAGE') private client: ClientGrpc) {
	}

	onModuleInit(): void {
		this.workflowService = this.client.getService<WorkflowServiceClient>('WorkflowService');
	}

	async listWorkflows(req: ListWorkflowsRequest): Promise<Workflow[]> {
		const res = this.workflowService.listWorkflows(req);
		const data = await Convertor.extractFromObservable(res);

		return data.workflows ?? [];
	}

	async getWorkflow(req: GetWorkflowRequest): Promise<Workflow | undefined> {
		const res = this.workflowService.getWorkflow(req);
		return Convertor.extractFromObservable(res);
	}

	async createWorkflow(req: CreateWorkflowRequest): Promise<Workflow> {
		const res = this.workflowService.createWorkflow(req);
		return Convertor.extractFromObservable(res);
	}

	async updateWorkflow(req: UpdateWorkflowRequest): Promise<Workflow> {
		const res = this.workflowService.updateWorkflow(req);
		return Convertor.extractFromObservable(res);
	}

	async deleteWorkflow(req: DeleteWorkflowRequest): Promise<Empty> {
		const res = this.workflowService.deleteWorkflow(req);
		return Convertor.extractFromObservable(res);
	}
}
