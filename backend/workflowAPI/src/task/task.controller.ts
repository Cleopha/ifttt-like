import { Controller, UseFilters, UseInterceptors, ValidationPipe } from '@nestjs/common';
import { Payload, RpcException } from '@nestjs/microservices';
import * as _ from 'lodash';

import {
	CreateTaskRequest,
	DeleteTaskRequest,
	GetTaskRequest,
	ListTasksRequest,
	ListTasksResponse,
	Task,
	TaskServiceController,
	TaskServiceControllerMethods,
	UpdateTaskRequest,
} from '@protos';
import { RpcExceptionInterceptor } from '@exception';
import { LoggingInterceptor } from '@logger';

import { TaskConvertor } from './task.convertor';
import { TaskService } from './task.service';

@Controller()
@UseInterceptors(new LoggingInterceptor())
@TaskServiceControllerMethods()
export class TaskController implements TaskServiceController {
	constructor(private taskService: TaskService, private taskConvertor: TaskConvertor) {
	}

	@UseFilters(new RpcExceptionInterceptor())
	async createTask(@Payload(new ValidationPipe({ whitelist: true })) req: CreateTaskRequest): Promise<Task> {
		const action = this.taskConvertor.grpcActionToPrismaAction(req.action);
		const type = this.taskConvertor.grpcTypeToPrismaType(req.type);

		const data = _.omit(req, [ 'action', 'type', 'workflowId' ]);

		const task = await this.taskService.createTask({ ...data, action, type }, req.workflowId);
		return this.taskConvertor.prismaTaskToGrpcTask(task);
	}

	@UseFilters(new RpcExceptionInterceptor())
	async listTasks(@Payload(new ValidationPipe({ whitelist: true })) req: ListTasksRequest): Promise<ListTasksResponse> {
		const { filterAction, filterType } = req;

		// X && Y || Z is a syntax to apply Y if X is defined or set value to Z
		const filters = {
			action: (filterAction != undefined && this.taskConvertor.grpcActionToPrismaAction(filterAction)) || undefined,
			type: (filterType != undefined && this.taskConvertor.grpcTypeToPrismaType(filterType)) || undefined,
		};

		const tasks = await this.taskService.listTasks(filters);
		return {
			tasks: tasks.map((prismaTask) => this.taskConvertor.prismaTaskToGrpcTask(prismaTask)),
		};
	}

	@UseFilters(new RpcExceptionInterceptor())
	async getTask(@Payload(new ValidationPipe({ whitelist: true })) req: GetTaskRequest): Promise<Task> {
		const task = await this.taskService.getTask(req.id);
		if (!task) {
			throw new RpcException('Task not found');
		}
		return this.taskConvertor.prismaTaskToGrpcTask(task);
	}

	@UseFilters(new RpcExceptionInterceptor())
	async updateTask(@Payload(new ValidationPipe({ whitelist: true })) req: UpdateTaskRequest): Promise<Task> {
		const { id, type, action } = req;
		const data = _.omit(req, [ 'type', 'action' ]);
		const convertedGrpcEnum = {
			action: (action != undefined && this.taskConvertor.grpcActionToPrismaAction(action)) || undefined,
			type: (type != undefined && this.taskConvertor.grpcTypeToPrismaType(type)) || undefined,
		};

		const task = await this.taskService.updateTask(id, { ...data, ...convertedGrpcEnum });
		return this.taskConvertor.prismaTaskToGrpcTask(task);
	}

	@UseFilters(new RpcExceptionInterceptor())
	async deleteTask(@Payload(new ValidationPipe({ whitelist: true })) req: DeleteTaskRequest): Promise<void> {
		await this.taskService.deleteTask(req.id);
	}
}
