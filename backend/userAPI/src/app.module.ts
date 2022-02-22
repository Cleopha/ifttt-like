import { Module } from '@nestjs/common';

import { UserModule } from '@user';
import { AuthModule } from '@auth';
import { PrismaModule } from '@db';
import { Config as ConfigModule } from '@config';
import { Session as SessionModule } from '@session';
import { Logger as LoggerModule } from '@logger';
import { TaskModule } from '@task';
import { WorkflowModule } from '@workflow';

@Module({
	imports: [
		UserModule,
		AuthModule,
		PrismaModule,
		ConfigModule,
		SessionModule,
		LoggerModule,
		TaskModule,
		WorkflowModule,
	],
})
export class AppModule {
}
