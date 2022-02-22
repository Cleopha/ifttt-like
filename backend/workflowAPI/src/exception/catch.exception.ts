import { Catch, ArgumentsHost, Logger, ExceptionFilter, BadRequestException } from '@nestjs/common';
import { RpcException } from '@nestjs/microservices';


@Catch()
export class RpcExceptionInterceptor implements ExceptionFilter {
	private logger = new Logger('RpcException');

	catch(exception: RpcException, host: ArgumentsHost): RpcException {
		if (exception.message.includes('Prisma')) {
			this.logger.error(exception)
			throw new RpcException(exception);
		}

		const ctx = host.getArgs()[2] as any;
		const handler = ctx.call.handler.path;

		// Retrieve parser data
		if (exception.name == BadRequestException.name) {
			const parserException = exception as any;
			if (parserException.response.message) {
				this.logger.error(`${ handler } - ${ parserException.name }: ${ parserException.response.message }`);
			}
			throw new RpcException(exception.getError());
		}

		const data = host.switchToRpc().getData();
		this.logger.error(`${ handler } with data '${ JSON.stringify(data) }' : ${ exception.getError() }`);

		// Required to parse pipes exception
		throw new RpcException(exception.getError());
	}
}