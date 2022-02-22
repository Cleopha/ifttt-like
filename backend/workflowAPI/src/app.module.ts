import { Module } from '@nestjs/common';

import { Config as ConfigModule } from '@config';
import { PrismaModule } from '@db';
import { TaskModule } from '@task';
import { WorkflowModule } from '@workflow';

@Module({
	imports: [ ConfigModule, PrismaModule, TaskModule, WorkflowModule ],
})
export class AppModule {
}
