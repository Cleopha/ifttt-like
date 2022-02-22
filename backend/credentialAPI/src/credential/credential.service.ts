import { Injectable } from '@nestjs/common';

import { Credential, Prisma, Service } from '@prisma/client';
import { PrismaService } from '@db';

@Injectable()
export class CredentialService {
	constructor(private prisma: PrismaService) {}

	async createCredential(data: Omit<Prisma.CredentialCreateInput, 'storage'>, owner: string): Promise<Credential> {
		return this.prisma.credential.create({
			data: {
				...data,
				storage: { connect: { owner } }
			}
		});
	}

	async getCredential(service: Service, owner: string): Promise<Credential | undefined> {
		return this.prisma.credential.findFirst({
			where: {
				AND: [ { service, storageId: owner } ]
			}
		});
	}

	async updateCredential(service: Service, owner: string, token: string): Promise<Credential | undefined> {
		const credential = await this.getCredential(service, owner);
		return this.prisma.credential.update({
			data: { token },
			where: { id: credential.id }
		});
	}

	async deleteCredential(service: Service, owner: string): Promise<Credential> {
		const credential = await this.getCredential(service, owner);
		return this.prisma.credential.delete({
			where: { id: credential.id }
		});
	}
}
