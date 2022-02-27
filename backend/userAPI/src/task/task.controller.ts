import { Body, Controller, Delete, Get, NotFoundException, Param, Post, Put, UseInterceptors } from '@nestjs/common';

import { WorkflowAPIClient } from '@workflow';
import { OwnerMiddleware } from '@auth';

import { TaskAPIClient } from './taskAPI.client';
import { Empty, Task } from '@protos';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { ApiTags } from '@nestjs/swagger';
import { Convertor } from '@util/convertor';
import { TransformTaskInterceptor } from './task.format';

@ApiTags('workflowAPI')
@Controller('user/:userId/workflow/:workflowId/task')
@UseInterceptors(TransformTaskInterceptor)
export class TaskController {
	constructor(private workflowClient: WorkflowAPIClient, private taskClient: TaskAPIClient) {
	}

	@OwnerMiddleware('userId')
	@Get()
	async listTasks(@Param('workflowId') id: string): Promise<Task[]> {
		try {
			const workflow = await this.workflowClient.getWorkflow({ id });
			return workflow.tasks ?? [];
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Get('/:taskId')
	async getTask(@Param('taskId') id: string): Promise<Task> {
		try {
			return await this.taskClient.getTask({ id });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Post()
	async createTask(@Body() dto: CreateTaskDto, @Param('workflowId') workflowId: string): Promise<Task> {
		try {
			dto.params = Convertor.objectToGrpcStruct(dto.params);

			return await this.taskClient.createTask({
				workflowId,
				...dto,
			});
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Put('/:taskId')
	async updateTask(@Body() dto: UpdateTaskDto, @Param('taskId') id: string): Promise<Task> {
		try {
			if (dto.params) {
				dto.params = Convertor.objectToGrpcStruct(dto.params);
			}

			return await this.taskClient.updateTask({
				id,
				...dto,
			});
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Delete('/:taskId')
	async deleteTask(@Param('taskId') id: string): Promise<Empty> {
		try {
			return await this.taskClient.deleteTask({ id });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}
}
