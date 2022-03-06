import { DynamicModule } from '@nestjs/common';

import { WinstonModule, utilities as WinstonModuleUtilities } from 'nest-winston';
import * as winston from 'winston';

// Reduce code by destructuration
const { transports, format } = winston;

/**
 * Integrate Winston Logger in userAPI
 */
export const Logger: DynamicModule = WinstonModule.forRoot({
	format: format.combine(
		format.timestamp(),
		WinstonModuleUtilities.format.nestLike()
	),
	transports: [
		new transports.Console(),
		new transports.File({ filename: 'logs/error.log', level: 'error', format: format.json() }),
		new transports.File({
			filename: 'logs/all.log', format: format.combine(
				format.json(),
				format.uncolorize()),
		}),
	]
});