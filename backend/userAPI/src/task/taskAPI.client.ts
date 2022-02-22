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
	private workflowService: TaskServiceClient;

	constructor(@Inject('TASK_PACKAGE') private client: ClientGrpc) {
	}

	onModuleInit(): void {
		this.workflowService = this.client.getService<TaskServiceClient>('TaskService');
	}

	async listTasks(req: ListTasksRequest): Promise<Task[]> {
		const res = this.workflowService.listTasks(req);
		const data = await Convertor.extractFromObservable(res);

		return data.tasks ?? [];
	}

	async getTask(req: GetTaskRequest): Promise<Task | undefined> {
		const res = this.workflowService.getTask(req);
		return Convertor.extractFromObservable(res);
	}

	async createTask(req: CreateTaskRequest): Promise<Task> {
		const res = this.workflowService.createTask(req);
		return Convertor.extractFromObservable(res);
	}

	async updateTask(req: UpdateTaskRequest): Promise<Task> {
		const res = this.workflowService.updateTask(req);
		return Convertor.extractFromObservable(res);
	}

	async deleteTask(req: DeleteTaskRequest): Promise<Empty> {
		const res = this.workflowService.deleteTask(req);
		return Convertor.extractFromObservable(res);
	}
}
