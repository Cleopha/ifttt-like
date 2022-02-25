import { ApiTags } from '@nestjs/swagger';
import { Controller, Get, Param, Post, Res } from '@nestjs/common';
import { AuthMiddleware, CurrentUser } from '../auth';
import { User } from '@user/entities';
import { Response } from 'express';

@ApiTags('workflowAPI')
@Controller('/user/workflow/:workflowId/task')
export class TaskOwnerController {
	@AuthMiddleware()
	@Get()
	async listTasks(@Res() res: Response, @CurrentUser() user: User, @Param('workflowId') id: string): Promise<void> {
		res.redirect(`/user/${user.id}/workflow/${id}/task`, 200);
	}

	@AuthMiddleware()
	@Post()
	async createTask(@Res() res: Response, @CurrentUser() user: User, @Param('workflowId') id: string): Promise<void> {
		res.redirect(`/user/${user.id}/workflow/${id}/task`, 201);
	}
}