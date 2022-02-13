import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import * as _ from 'lodash';

import { Task } from '@protos';
import { Convertor } from '@util/convertor';

type Response = Task | Task[];

@Injectable()
export class TransformTaskInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<Response> {
		return next.handle().pipe(map(data => {
			// Ignore empty response
			if (_.isEmpty(data)) {
				return data;
			}

			if (Array.isArray(data)) {
				return data.map((e) => Convertor.formatGrpcTaskToTypescript(e));
			}
			return Convertor.formatGrpcTaskToTypescript(data);
		}));
	}
}