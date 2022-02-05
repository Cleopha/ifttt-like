import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { ConfigService } from '@nestjs/config';
import { IApiConfig } from './config/config.data';
import { Logger } from '@nestjs/common';


async function bootstrap(): Promise<void> {
	const app = await NestFactory.create(AppModule);
	const config = app.get(ConfigService);
	const { host, port } = config.get<IApiConfig>('api')

	await app.connectMicroservice<MicroserviceOptions>({
		transport: Transport.GRPC,
		options: {
			package: [ 'area.workflow', 'area.task' ],
			protoPath: [ __dirname + '/protos/workflow.proto', __dirname + '/protos/task.proto' ],
			url: `${host}:${port}`,
		},
	});

	await app.startAllMicroservices();
	Logger.log(`Workflow gRPC service listening on ${host}:${port}`)
}

bootstrap();
