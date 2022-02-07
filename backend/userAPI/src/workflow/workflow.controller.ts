import { Controller, Get, Param } from '@nestjs/common';

import { Workflow } from '@protos';
import { WorkflowAPIClient } from './workflowAPI.client';

@Controller('/user/:userId/workflow')
export class WorkflowController {
	constructor(private workflowClient: WorkflowAPIClient) {}

	@Get()
	async listWorkflow(@Param('userId') owner: string): Promise<Workflow[]> {
		return this.workflowClient.listWorkflow(owner)
	}
}
