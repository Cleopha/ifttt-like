import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

import { Task, Workflow } from '@protos';
import { Convertor } from '@util/convertor';

type Response = Workflow | Workflow[];

@Injectable()
export class TransformWorkflowInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<Response> {
		const convertTasks = (tasks: Task[]): Task[] => tasks.map((task) => Convertor.formatGrpcTaskToTypescript(task));

		return next.handle().pipe(map((data: Response) => {
			// Ignore empty response
			if (!data) {
				return data;
			}

			if (Array.isArray(data)) {
				return data.map((e) => ({ ...e, tasks: convertTasks(e.tasks ?? []) }));
			}
			return { ...data, tasks: convertTasks(data.tasks ?? []) };
		}));
	}
}