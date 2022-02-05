import { Module } from '@nestjs/common';
import { WorkflowService } from './workflow.service';
import { PrismaModule } from '../prisma';
import { WorkflowController } from './workflow.controller';
import { TaskModule } from '../task/task.module';

@Module({
	imports: [ PrismaModule, TaskModule ],
	providers: [ WorkflowService ],
	controllers: [ WorkflowController ],
})
export class WorkflowModule {
}
