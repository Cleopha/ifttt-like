import { Module } from '@nestjs/common';

import { PrismaModule } from '@db';

import { TaskService } from './task.service';
import { TaskController } from './task.controller';
import { TaskConvertor } from './task.convertor';

@Module({
	imports: [ PrismaModule ],
	providers: [ TaskService, TaskConvertor ],
	controllers: [ TaskController ],
	exports: [ TaskConvertor ],
})
export class TaskModule {}
