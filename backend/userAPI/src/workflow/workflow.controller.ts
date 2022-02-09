import {
	Body,
	Controller,
	Delete,
	Get,
	InternalServerErrorException,
	NotFoundException,
	Param,
	Post,
	Put
} from '@nestjs/common';

import { Empty, Workflow } from '@protos';
import { WorkflowAPIClient } from './workflowAPI.client';
import { ApiTags } from '@nestjs/swagger';
import { CreateWorkflowDto } from './dto/create-workflow.dto';
import { UpdateWorkflowDto } from './dto/update-workflow.dto';
import { OwnerMiddleware } from '../auth';

@ApiTags('workflowAPI')
@Controller('/user/:userId/workflow')
export class WorkflowController {
	constructor(private workflowClient: WorkflowAPIClient) {}

	@OwnerMiddleware('userId')
	@Get()
	async listWorkflows(@Param('userId') owner: string): Promise<Workflow[]> {
		try {
			return await this.workflowClient.listWorkflows({ owner });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Get('/:workflowId')
	async getWorkflow(@Param('workflowId') id: string): Promise<Workflow | undefined> {
		try {
			return await this.workflowClient.getWorkflow({ id });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Post()
	async createWorkflow(@Body() dto: CreateWorkflowDto, @Param('userId') owner: string): Promise<Workflow> {
		try {
			return await this.workflowClient.createWorkflow({ owner, name: dto.name, tasks: [] });
		} catch (e) {
			throw new InternalServerErrorException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Put('/:workflowId')
	async updateWorkflow(@Body() dto: UpdateWorkflowDto, @Param('workflowId') id: string): Promise<Workflow> {
		try {
			return await this.workflowClient.updateWorkflow({ id, name: dto.name });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Delete('/:workflowId')
	async deleteWorkflow(@Param('workflowId') id: string): Promise<Empty> {
		try {
			return await this.workflowClient.deleteWorkflow({ id });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}
}
