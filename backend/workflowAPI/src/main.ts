import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';


async function bootstrap(): Promise<void> {
	const app = await NestFactory.create(AppModule);

	await app.connectMicroservice<MicroserviceOptions>({
		transport: Transport.GRPC,
		options: {
			package: [ 'area.workflow', 'area.task' ],
			protoPath: [ __dirname + '/protos/workflow.proto', __dirname + '/protos/task.proto' ],
			url: '127.0.0.1:6000',
		},
	});

	await app.startAllMicroservices();
}

bootstrap();
