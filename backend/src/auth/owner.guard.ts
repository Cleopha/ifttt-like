import {
	applyDecorators,
	CanActivate,
	CustomDecorator,
	ExecutionContext,
	Injectable,
	SetMetadata, UseGuards,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { User, Role } from '@user/entities';
import { AuthGuard } from './auth.guard';

// Give self location
// Set by default to id
export const SelfLocation = (self = 'id'): CustomDecorator => SetMetadata('self', self)

// eslint-disable-next-line @typescript-eslint/naming-convention,@typescript-eslint/explicit-function-return-type
export function OwnerMiddleware(self = 'id') {
	return applyDecorators(
		UseGuards(AuthGuard),
		SelfLocation(self),
		UseGuards(OwnerGuard),
	)
}

/**
 * OwnerGuard protect the endpoint to grant access
 * if the resource is owned by the user
 * or requested by an administrator
 *
 * @warning This guard do not work without AuthGuard
 */
@Injectable()
export class OwnerGuard implements CanActivate {
	constructor(private reflector: Reflector) {}

	async canActivate(context: ExecutionContext): Promise<boolean> {
		const request = context.switchToHttp().getRequest()

		// Retrieve current user
		const { user }: { user: User} = request;
		if (!user) {
			return false;
		}

		// Retrieve endpoint id
		const self = this.reflector.get<string>('self', context.getHandler());
		if (!self) {
			return false
		}

		// Verify
		const id = request.params[self];
		return (user.role == Role.ADMIN || user.id == id);
	}
}