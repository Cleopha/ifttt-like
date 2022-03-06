import {
	Body,
	Controller,
	Delete,
	Get,
	InternalServerErrorException,
	NotFoundException,
	Param,
	Post,
	Put, UseInterceptors
} from '@nestjs/common';

import { Empty, Workflow } from '@protos';
import { WorkflowAPIClient } from './workflowAPI.client';
import {
	ApiCreatedResponse,
	ApiInternalServerErrorResponse,
	ApiOkResponse, ApiOperation,
	ApiTags,
	ApiUnauthorizedResponse
} from '@nestjs/swagger';
import { CreateWorkflowDto } from './dto/create-workflow.dto';
import { UpdateWorkflowDto } from './dto/update-workflow.dto';
import { OwnerMiddleware } from '@auth';
import { TransformWorkflowInterceptor } from './workflow.format';
import { WorkflowRO } from './ro/workflow.ro';

@ApiTags('workflowAPI')
@Controller('/user/:userId/workflow')
@UseInterceptors(TransformWorkflowInterceptor)
export class WorkflowController {
	constructor(private workflowClient: WorkflowAPIClient) {}

	@OwnerMiddleware('userId')
	@Get()
	@ApiOperation({ summary: 'List all workflows of the user'})
	@ApiOkResponse({ isArray: true, type: WorkflowRO })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async listWorkflows(@Param('userId') owner: string): Promise<Workflow[]> {
		try {
			return await this.workflowClient.listWorkflows({ owner });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Get('/:workflowId')
	@ApiOkResponse({ type: WorkflowRO })
	@ApiOperation({ summary: 'Get a workflow of the user'})
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async getWorkflow(@Param('workflowId') id: string): Promise<Workflow | undefined> {
		try {
			return await this.workflowClient.getWorkflow({ id });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Post()
	@ApiOperation({ summary: 'Create a workflow'})
	@ApiCreatedResponse({ type: WorkflowRO })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async createWorkflow(@Body() dto: CreateWorkflowDto, @Param('userId') owner: string): Promise<Workflow> {
		try {
			return await this.workflowClient.createWorkflow({ owner, name: dto.name, tasks: [] });
		} catch (e) {
			throw new InternalServerErrorException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Put('/:workflowId')
	@ApiOperation({ summary: 'Update a workflow'})
	@ApiOkResponse({ type: WorkflowRO })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async updateWorkflow(@Body() dto: UpdateWorkflowDto, @Param('workflowId') id: string): Promise<Workflow> {
		try {
			return await this.workflowClient.updateWorkflow({ id, name: dto.name });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Delete('/:workflowId')
	@ApiOperation({ summary: 'Delete a workflow'})
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	async deleteWorkflow(@Param('workflowId') id: string): Promise<Empty> {
		try {
			return await this.workflowClient.deleteWorkflow({ id });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}
}
