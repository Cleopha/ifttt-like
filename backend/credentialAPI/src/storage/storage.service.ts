import { Injectable } from '@nestjs/common';

import { Storage, Prisma, Credential } from '@prisma/client';
import { PrismaService } from '@db';

export type StorageWithCredentials = Storage & { credentials: Credential[] };

@Injectable()
export class StorageService {
	constructor(private prisma: PrismaService) {
	}

	async getStorage(owner: string): Promise<StorageWithCredentials> {
		return this.prisma.storage.findUnique({
			where: { owner },
			include: { credentials: true }
		});
	}

	async createStorage(data: Omit<Prisma.StorageCreateInput, 'credentials'>): Promise<StorageWithCredentials> {
		return this.prisma.storage.create({
			data,
			include: { credentials: true }
		});
	}

	async deleteStorage(owner: string): Promise<StorageWithCredentials> {
		return this.prisma.storage.delete({
			where: { owner },
			include: { credentials: true },
		});
	}
}
