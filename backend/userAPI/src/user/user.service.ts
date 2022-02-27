import { Injectable } from '@nestjs/common';

import { PrismaService } from '@db'
	;
import { CreateUserDto, UpdateUserDto } from './dto';
import { User } from './entities';
import { PrismaException } from '../error';

@Injectable()
export class UserService {
	constructor(private prisma: PrismaService) {
	}

	async create(data: CreateUserDto): Promise<User> {
		return this.prisma.user.create({
			data,
		});
	}

	async list(): Promise<User[]> {
		try {
			return this.prisma.user.findMany();
		} catch (e) {
			throw new PrismaException(e.code, e.msg);
		}
	}

	async getById(id: string): Promise<User | null> {
		try {
			return this.prisma.user.findUnique({
				where: { id },
			});
		} catch (e) {
			throw new PrismaException(e.code, e.msg);
		}
	}

	async getByEmail(email: string): Promise<User | null> {
		try {
			return this.prisma.user.findUnique({
				where: { email },
			});
		} catch (e) {
			throw new PrismaException(e.code, e.msg);
		}
	}

	async update(id: string, data: UpdateUserDto): Promise<User | null> {
		try {
			return this.prisma.user.update({
				where: { id },
				data,
			});
		} catch (e) {
			throw new PrismaException(e.code, e.msg);
		}
	}

	async delete(id: string): Promise<User | null> {
		try {
			return this.prisma.user.delete({
				where: { id },
			});
		} catch (e) {
			throw new PrismaException(e.code, e.msg);
		}
	}
}
