import { Module } from '@nestjs/common';
import { Config as ConfigModule } from './config';
import { PrismaModule } from './prisma';
import { TaskModule } from './task/task.module';
import { WorkflowModule } from './workflow/workflow.module';

@Module({
	imports: [ ConfigModule, PrismaModule, TaskModule, WorkflowModule ],
})
export class AppModule {
}
