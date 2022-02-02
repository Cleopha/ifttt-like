import { Module } from '@nestjs/common';
import { WorkflowService } from './workflow.service';
import { PrismaModule } from '../prisma';

@Module({
	imports: [ PrismaModule ],
	providers: [ WorkflowService ],
})
export class WorkflowModule {}
