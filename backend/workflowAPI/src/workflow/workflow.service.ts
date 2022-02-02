import { Injectable } from '@nestjs/common';

import { Prisma, Workflow } from '@prisma/client';

import { PrismaService } from '../prisma';

@Injectable()
export class WorkflowService {
	constructor(private prisma: PrismaService) {
	}

	async listWorkflows(): Promise<Workflow[]> {
		return this.prisma.workflow.findMany({
			include: { tasks: true },
		});
	}

	async getWorkflow(id: string): Promise<Workflow | undefined> {
		return this.prisma.workflow.findUnique({
			include: { tasks: true },
			where: { id },
		});
	}

	async createWorkflow(data: Omit<Prisma.WorkflowCreateInput, 'tasks'>): Promise<Workflow> {
		return this.prisma.workflow.create({
			data,
		});
	}

	async updateTask(id: string, data: Omit<Prisma.WorkflowUpdateInput, 'tasks'>): Promise<Workflow> {
		return this.prisma.workflow.update({
			data,
			where: { id },
		});
	}

	async deleteTask(id: string): Promise<Workflow> {
		return this.prisma.workflow.delete({
			where: { id },
		});
	}
}
