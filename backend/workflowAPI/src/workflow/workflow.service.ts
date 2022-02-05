import { Injectable } from '@nestjs/common';

import { Prisma, Workflow, Task } from '@prisma/client';

import { PrismaService } from '../prisma';

export type WorkflowWithTasks = Workflow & { tasks: Task[] }

export interface IListWorkflowFilter {
	owner?: string
}

@Injectable()
export class WorkflowService {
	constructor(private prisma: PrismaService) {
	}

	async listWorkflows(filters: IListWorkflowFilter): Promise<WorkflowWithTasks[]> {
		const { owner } = filters;

		return this.prisma.workflow.findMany({
			where: { owner },
			include: { tasks: true },
		});
	}

	async getWorkflow(id: string): Promise<WorkflowWithTasks | undefined> {
		return this.prisma.workflow.findUnique({
			where: { id },
			include: { tasks: true },
		});
	}

	async createWorkflow(data: Omit<Prisma.WorkflowCreateInput, 'tasks'>): Promise<WorkflowWithTasks> {
		return this.prisma.workflow.create({
			data,
			include: { tasks: true },
		});
	}

	async updateTask(id: string, data: Omit<Prisma.WorkflowUpdateInput, 'tasks'>): Promise<WorkflowWithTasks> {
		return this.prisma.workflow.update({
			data,
			where: { id },
			include: { tasks: true },
		});
	}

	async deleteTask(id: string): Promise<WorkflowWithTasks> {
		return this.prisma.workflow.delete({
			where: { id },
			include: { tasks: true },
		});
	}
}
