import { Module } from '@nestjs/common';

import { PrismaModule } from '../prisma';
import { TaskService } from './task.service';

@Module({
	imports: [ PrismaModule ],
	providers: [ TaskService ],
})
export class TaskModule {}
