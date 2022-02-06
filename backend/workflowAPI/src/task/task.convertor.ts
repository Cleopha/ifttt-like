import { Injectable } from '@nestjs/common';
import * as Prisma from '@prisma/client';
import * as _ from 'lodash';

import { Task, TaskAction, TaskType } from '@protos';

@Injectable()
export class TaskConvertor {
	grpcActionToPrismaAction(action: TaskAction): Prisma.TaskAction {
		const key = Object.keys(TaskAction)[Object.values(TaskAction).indexOf(action)];
		return (Prisma.TaskAction as never)[key];
	}

	grpcTypeToPrismaType(action: TaskType): Prisma.TaskType {
		const key = Object.keys(TaskType)[Object.values(TaskType).indexOf(action)];
		return (Prisma.TaskType as never)[key];
	}

	prismaTypeToGrpcType(action: Prisma.TaskType): TaskType {
		const key = Object.keys(Prisma.TaskType)[Object.values(Prisma.TaskType).indexOf(action)];
		return (TaskType as never)[key];
	}

	prismaActionToGrpcAction(action: Prisma.TaskAction): TaskAction {
		const key = Object.keys(Prisma.TaskAction)[Object.values(Prisma.TaskAction).indexOf(action)];
		return (TaskType as never)[key];
	}

	prismaTaskToGrpcTask(task: Prisma.Task): Task {
		const { action, type, params } = task;
		const data = _.omit(task, [ 'action', 'type', 'params' ]);
		return {
			...data,
			action: this.prismaActionToGrpcAction(action),
			type: this.prismaTypeToGrpcType(type),
			params: (params as Prisma.Prisma.JsonObject),
		};
	}
}