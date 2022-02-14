// Enable module alias
import 'module-alias/register';

import { NestFactory } from '@nestjs/core';
import { Logger } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';

import { ConfigService, IApiConfig } from '@config';

import { AppModule } from './app.module';

async function bootstrap() {
	const app = await NestFactory.create(AppModule);
	const config = app.get(ConfigService);
	const { host, port } = config.get<IApiConfig>('api');

	await app.connectMicroservice<MicroserviceOptions>({
		transport: Transport.GRPC,
		options: {
			package: [ 'area.credential' ],
			protoPath: [ __dirname + '/protos/credential.proto' ],
			url: `${ host }:${ port }`,
			loader: {
				objects: true
			}
		},
	});

	await app.startAllMicroservices();
	Logger.log(`Workflow gRPC service listening on ${ host }:${ port }`);
}

bootstrap();
