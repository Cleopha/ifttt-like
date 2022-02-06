import { Controller, UseFilters, UseInterceptors, ValidationPipe } from '@nestjs/common';
import { Payload, RpcException } from '@nestjs/microservices';

import {
	CreateWorkflowRequest,
	DeleteWorkflowRequest,
	GetWorkflowRequest,
	ListWorkflowsRequest,
	ListWorkflowsResponse,
	UpdateWorkflowRequest,
	Workflow,
	WorkflowServiceController,
	WorkflowServiceControllerMethods
} from '@protos';
import { TaskConvertor } from '@task';
import { RpcExceptionInterceptor } from '@exception';
import { LoggingInterceptor } from '@logger';

import { WorkflowService, WorkflowWithTasks } from './workflow.service';

@Controller()
@UseInterceptors(new LoggingInterceptor())
@WorkflowServiceControllerMethods()
export class WorkflowController implements WorkflowServiceController {
	constructor(private workflowService: WorkflowService, private taskConvertor: TaskConvertor) {}

	private formatWorkflow(workflow: WorkflowWithTasks): Workflow {
		return {
			...workflow,
			tasks: workflow.tasks.map((task) => this.taskConvertor.prismaTaskToGrpcTask(task))
		};
	}

	@UseFilters(new RpcExceptionInterceptor())
	async listWorkflows(@Payload(new ValidationPipe({ whitelist: true })) req: ListWorkflowsRequest): Promise<ListWorkflowsResponse> {
		const workflows = await this.workflowService.listWorkflows(req);
		return {
			workflows: workflows.map((workflow) => this.formatWorkflow(workflow))
		};
	}

	@UseFilters(new RpcExceptionInterceptor())
	async getWorkflow(@Payload(new ValidationPipe({ whitelist: true })) req: GetWorkflowRequest): Promise<Workflow> {
		const workflow = await this.workflowService.getWorkflow(req.id);
		if (!workflow) {
			throw new RpcException('Workflow not found');
		}
		return this.formatWorkflow(workflow);
	}

	@UseFilters(new RpcExceptionInterceptor())
	async createWorkflow(@Payload(new ValidationPipe({ whitelist: true })) req: CreateWorkflowRequest): Promise<Workflow> {
		const { name, owner } = req;
		const workflow = await this.workflowService.createWorkflow({ name, owner });
		return this.formatWorkflow(workflow);
	}

	@UseFilters(new RpcExceptionInterceptor())
	async updateWorkflow(@Payload(new ValidationPipe({ whitelist: true })) req: UpdateWorkflowRequest): Promise<Workflow> {
		const { name, owner, id } = req;
		const workflow = await this.workflowService.updateTask(id, { name, owner });
		return this.formatWorkflow(workflow);
	}

	@UseFilters(new RpcExceptionInterceptor())
	async deleteWorkflow(@Payload(new ValidationPipe({ whitelist: true })) req: DeleteWorkflowRequest): Promise<void> {
		await this.workflowService.deleteTask(req.id);
	}
}
