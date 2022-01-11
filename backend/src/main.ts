import { NestFactory } from '@nestjs/core';
import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SwaggerModule } from '@nestjs/swagger';

import { AppModule } from './app.module';
import AppDoc from './app.doc';

async function bootstrap() {
	const app = await NestFactory.create(AppModule);

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
		Logger.log(`Server listening on ${host}:${port}`);
	});
}

bootstrap();
