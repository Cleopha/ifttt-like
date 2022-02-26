import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import * as _ from 'lodash';

import { Storage } from '@protos';
import { Convertor } from '@util/convertor';

type Response = Storage;

@Injectable()
export class TransformStorageInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<Response> {
		return next.handle().pipe(map((data: Storage) => {
			// Ignore empty response
			if (_.isEmpty(data)) {
				return data;
			}

			return {
				...data,
				credentials: (data.credentials != undefined) && data.credentials.map(c => Convertor.formatGrpcCredentialToTypescript(c)) || []
			};
		}));
	}
}