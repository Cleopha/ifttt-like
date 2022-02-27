// Enable module alias
import 'module-alias/register';

import { NestFactory } from '@nestjs/core';
import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SwaggerModule } from '@nestjs/swagger';

import * as morgan from 'morgan';
import { WINSTON_MODULE_NEST_PROVIDER } from 'nest-winston';

import { AppModule } from './app.module';
import AppDoc from '@doc';

async function bootstrap(): Promise<void> {
	const app = await NestFactory.create(AppModule);

	// Enable cors
	// Default cors should allow any origin with any methods and headers
	// TODO: Improve security with selected host and headers
	app.enableCors({
		credentials: true,
	});

	// Use winston logger
	app.useLogger(app.get(WINSTON_MODULE_NEST_PROVIDER));
	const logger = new Logger('Request');
	app.use(morgan('dev', {
			stream: {
				write: (msg) => logger.log(msg.replace('\n', ''))
			}
		}),
	);


	// Retrieve configuration
	const configService = app.get(ConfigService);

	// Apply body validator
	app.useGlobalPipes(new ValidationPipe({ transform: true }));

	// Generate doc
	SwaggerModule.setup('docs', app, SwaggerModule.createDocument(app, AppDoc));

	// Run server
	const port = configService.get<number>('api.port');
	const host = configService.get<string>('api.host');

	await app.listen(port, host, () => {
		Logger.log(`Server listening on ${ host }:${ port }`);
	});
}

bootstrap();
