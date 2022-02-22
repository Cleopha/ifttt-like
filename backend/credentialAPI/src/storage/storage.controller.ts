import { Controller, UseFilters, UseInterceptors, ValidationPipe } from '@nestjs/common';
import { Payload, RpcException } from '@nestjs/microservices';

import {
	CreateStorageRequest,
	DeleteStorageRequest,
	StorageServiceController,
	Storage,
	GetStorageRequest, StorageServiceControllerMethods
} from '@protos';
import { LoggingInterceptor } from '@logger';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime';
import { CredentialConvertor } from '@credential';
import { RpcExceptionInterceptor } from '@exception';

import { StorageService, StorageWithCredentials } from './storage.service';

@Controller()
@UseInterceptors(new LoggingInterceptor())
@StorageServiceControllerMethods()
export class StorageController implements StorageServiceController {
	constructor(private storageService: StorageService, private credentialConvertor: CredentialConvertor) {
	}

	private formatStorage(storage: StorageWithCredentials): Storage {
		if (!storage.credentials) {
			return { ...storage, credentials: [] };
		}
		return {
			...storage,
			credentials: storage.credentials.map((cred) => this.credentialConvertor.prismaCredentialToGrpcCredential(cred))
		};

	}

	@UseFilters(new RpcExceptionInterceptor)
	async createStorage(@Payload(new ValidationPipe({ whitelist: true })) req: CreateStorageRequest): Promise<Storage> {
		const { owner } = req;
		const storage = await this.storageService.createStorage({ owner });
		return this.formatStorage(storage);
	}

	@UseFilters(new RpcExceptionInterceptor)
	async deleteStorage(@Payload(new ValidationPipe({ whitelist: true })) req: DeleteStorageRequest): Promise<void> {
		try {
			const { owner } = req;
			await this.storageService.deleteStorage(owner);
		} catch (e) {
			if (e instanceof PrismaClientKnownRequestError) {
				if (e.code == 'P2025') {
					throw new RpcException('Credential not found');
				}
			}
			throw new RpcException(e.message);
		}
	}

	@UseFilters(new RpcExceptionInterceptor)
	async getStorage(@Payload(new ValidationPipe({ whitelist: true })) req: GetStorageRequest): Promise<Storage> {
		const { owner } = req;
		const storage = await this.storageService.getStorage(owner);
		if (!storage) {
			throw new RpcException('storage not found');
		}
		return this.formatStorage(storage);
	}
}
