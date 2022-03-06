import { createParamDecorator, ExecutionContext } from '@nestjs/common';

import { User } from '@user/entities';

/**
 * CurrentUser is a decorator to retrieve the current logged user
 * from the session
 */
export const CurrentUser = createParamDecorator(
	(data: unknown, ctx: ExecutionContext): User => {
		const request = ctx.switchToHttp().getRequest();
		return request.user;
	},
);