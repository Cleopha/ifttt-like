import { Module } from '@nestjs/common';

import { PrismaModule } from '@db';
import { TaskModule } from '@task';

import { WorkflowService } from './workflow.service';
import { WorkflowController } from './workflow.controller';


@Module({
	imports: [ PrismaModule, TaskModule ],
	providers: [ WorkflowService ],
	controllers: [ WorkflowController ],
})
export class WorkflowModule {
}
