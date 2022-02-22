import { Controller, Get, Body, Patch, Param, Delete, HttpStatus, HttpCode, Session } from '@nestjs/common';

import { AuthMiddleware, CurrentUser, OwnerMiddleware } from '@auth';

import { UserService } from './user.service';
import { UpdateUserDto } from './dto';
import { User, Role } from './entities';
import { ApiTags } from '@nestjs/swagger';
import { ISession } from '../session';

@ApiTags('user')
@Controller('user')
export class UserController {
	constructor(private readonly userService: UserService) {
	}

	@AuthMiddleware(Role.ADMIN)
	@HttpCode(HttpStatus.OK)
	@Get()
	async list(): Promise<User[]> {
		return this.userService.list();
	}

	@AuthMiddleware()
	@HttpCode(HttpStatus.OK)
	@Get('/me')
	async me(@CurrentUser() user: User): Promise<User> {
		return user;
	}

	@OwnerMiddleware()
	@HttpCode(HttpStatus.OK)
	@Get(':id')
	async get(@Param('id') id: string): Promise<User | null> {
		return this.userService.getById(id);
	}

	@OwnerMiddleware()
	@HttpCode(HttpStatus.OK)
	@Patch(':id')
	async update(
		@Param('id') id: string,
		@Body() updateUserDto: UpdateUserDto,
	): Promise<User | null> {
		return this.userService.update(id, updateUserDto);
	}

	@OwnerMiddleware()
	@HttpCode(HttpStatus.OK)
	@Delete(':id')
	async delete(@Param('id') id: string, @Session() session: ISession): Promise<User | null> {
		if (id === session.user.id) {
			session.destroy(null);
		}
		return this.userService.delete(id);
	}
}
