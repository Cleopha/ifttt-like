import {
	Injectable,
	CanActivate,
	ExecutionContext, SetMetadata, CustomDecorator, forwardRef, Inject, applyDecorators, UseGuards,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';

import { UserService } from '@user/user.service';
import { Role } from '@prisma/client';

// Decorator to specify which role has access to the handler
export const Roles = (...roles: Role[]): CustomDecorator => SetMetadata('roles', roles);

// eslint-disable-next-line @typescript-eslint/naming-convention,@typescript-eslint/explicit-function-return-type
export function AuthMiddleware(...roles: Role[]) {
	return applyDecorators(
		Roles(...roles),
		UseGuards(AuthGuard)
	)
}

@Injectable()
export class AuthGuard implements CanActivate {
	constructor(
		@Inject(forwardRef(() => UserService)) private readonly userService: UserService,
		private reflector: Reflector) {}

	private static checkPermission(roles: string[], userRole: string): boolean {
		return roles.includes(userRole);
	}

	async canActivate(context: ExecutionContext): Promise<boolean> {
		const request = context.switchToHttp().getRequest();
		const { user } = request.session;
		if (!user) {
			return false;
		}

		request.user = await this.userService.getById(user.id);

		const roles = this.reflector.get<string[]>('roles', context.getHandler());
		if (!roles) {
			// Any logged user can access the handler
			return true;
		}

		return AuthGuard.checkPermission(roles, request.user.role);
	}
}