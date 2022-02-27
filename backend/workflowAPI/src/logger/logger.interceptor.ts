import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		const ctx = context.getArgs()[2] as any;
		const handler = ctx.call.handler.path;

		const type = context.getType();
		const data = context.switchToRpc().getData();

		Logger.log(`Received ${type} call to ${handler} with data: '${JSON.stringify(data)}'`)
		return next
			.handle()
	}
}