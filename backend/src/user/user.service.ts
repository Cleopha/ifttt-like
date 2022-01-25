import { Injectable } from '@nestjs/common';

import { PrismaService } from '@db'
	;
import { CreateUserDto, UpdateUserDto } from './dto';
import { User } from './entities';

@Injectable()
export class UserService {
	constructor(private prisma: PrismaService) {}

	async create(data: CreateUserDto): Promise<User> {
		return this.prisma.user.create({
			data,
		});
	}

	async list(): Promise<User[]> {
		return this.prisma.user.findMany();
	}

	async getById(id: string): Promise<User | null> {
		return this.prisma.user.findUnique({
			where: { id },
		});
	}

	async getByEmail(email: string): Promise<User | null> {
		return this.prisma.user.findUnique({
			where: { email },
		});
	}

	async update(id: string, data: UpdateUserDto): Promise<User | null> {
		return this.prisma.user.update({
			where: { id },
			data,
		});
	}

	async delete(id: string): Promise<User | null> {
		return this.prisma.user.delete({
			where: { id },
		});
	}
}
