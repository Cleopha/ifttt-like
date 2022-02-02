import { Injectable } from '@nestjs/common';

import { Task, Prisma } from '@prisma/client';

import { PrismaService } from '../prisma';


export interface IListTaskFilter {
	type?: Prisma.TaskWhereInput['type'];
	action?: Prisma.TaskWhereInput['action'];
}

@Injectable()
export class TaskService {
	constructor(private prisma: PrismaService) {}

	async listTasks(filter?: IListTaskFilter): Promise<Task[]> {
		return this.prisma.task.findMany({
			where: filter,
		});
	}

	async getTask(id: string): Promise<Task | undefined> {
		return this.prisma.task.findUnique({
			where: { id },
		});
	}

	async createTask(data: Omit<Prisma.TaskCreateInput, 'workflow'>, workflowId: string): Promise<Task> {
		return this.prisma.task.create({
			data: {
				...data,
				workflow: {
					connect: { id: workflowId },
				},
			},
		});
	}

	async updateTask(id: string, data: Omit<Prisma.TaskUpdateInput, 'workflow' | 'id'>): Promise<Task> {
		return this.prisma.task.update({
			data,
			where: { id },
		});
	}

	async deleteTask(id: string): Promise<Task> {
		return this.prisma.task.delete({
			where: { id },
		});
	}
}
