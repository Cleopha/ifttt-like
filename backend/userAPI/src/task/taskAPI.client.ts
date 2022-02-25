import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientGrpc } from '@nestjs/microservices';

import {
	CreateTaskRequest,
	DeleteTaskRequest, Empty,
	GetTaskRequest,
	ListTasksRequest,
	UpdateTaskRequest,
	Task,
	TaskServiceClient
} from '@protos';
import { Convertor } from '@util/convertor';

@Injectable()
export class TaskAPIClient implements OnModuleInit {
	private taskService: TaskServiceClient;

	constructor(@Inject('TASK_PACKAGE') private client: ClientGrpc) {
	}

	onModuleInit(): void {
		this.taskService = this.client.getService<TaskServiceClient>('TaskService');
	}

	async listTasks(req: ListTasksRequest): Promise<Task[]> {
		const res = this.taskService.listTasks(req);
		const data = await Convertor.extractFromObservable(res);

		return data.tasks ?? [];
	}

	async getTask(req: GetTaskRequest): Promise<Task | undefined> {
		const res = this.taskService.getTask(req);
		return Convertor.extractFromObservable(res);
	}

	async createTask(req: CreateTaskRequest): Promise<Task> {
		const res = this.taskService.createTask(req);
		return Convertor.extractFromObservable(res);
	}

	async updateTask(req: UpdateTaskRequest): Promise<Task> {
		const res = this.taskService.updateTask(req);
		return Convertor.extractFromObservable(res);
	}

	async deleteTask(req: DeleteTaskRequest): Promise<Empty> {
		const res = this.taskService.deleteTask(req);
		return Convertor.extractFromObservable(res);
	}
}
