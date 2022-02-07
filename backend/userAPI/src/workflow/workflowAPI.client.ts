import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientGrpc } from '@nestjs/microservices';

import { Workflow, WorkflowServiceClient } from '@protos';
import { Convertor } from '@util/convertor';

@Injectable()
export class WorkflowAPIClient implements OnModuleInit {
	private workflowService: WorkflowServiceClient;

	constructor(@Inject('WORKFLOW_PACKAGE') private client: ClientGrpc) {}

	onModuleInit(): void {
		this.workflowService = this.client.getService<WorkflowServiceClient>('WorkflowService');
	}

	async listWorkflow(owner: string): Promise<Workflow[]> {
		const res = this.workflowService.listWorkflows({ owner });
		const data = await Convertor.extractFromObservable(res);

		return data.workflows ?? []
	}
}
