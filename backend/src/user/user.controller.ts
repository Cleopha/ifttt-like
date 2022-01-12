import { Controller, Get, Body, Patch, Param, Delete } from '@nestjs/common';

import { UserService } from './user.service';
import { UpdateUserDto } from './dto';
import { User } from './entities';

@Controller('user')
export class UserController {
	constructor(private readonly userService: UserService) {}

	@Get()
	async list(): Promise<User[]> {
		return this.userService.list();
	}

	@Get(':id')
	async get(@Param('id') id: string): Promise<User | null> {
		return this.userService.getById(id);
	}

	@Patch(':id')
	async update(
		@Param('id') id: string,
		@Body() updateUserDto: UpdateUserDto,
	): Promise<User | null> {
		return this.userService.update(id, updateUserDto);
	}

	@Delete(':id')
	async delete(@Param('id') id: string): Promise<User | null> {
		return this.userService.delete(id);
	}
}
