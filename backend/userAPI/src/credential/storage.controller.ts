import {
	Controller,
	Delete,
	Get,
	NotFoundException,
	Param,
	Post,
	UseInterceptors
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

import { Storage } from '@protos';
import { OwnerMiddleware } from '@auth';

import { TransformStorageInterceptor } from './storage.format';
import { CredentialAPIStorageClient } from './client/credentialAPIStorage.client';

@ApiTags('CredentialAPI')
@Controller('/user/:userId/storage')
@UseInterceptors(TransformStorageInterceptor)
export class StorageController {
	constructor(private storageClient: CredentialAPIStorageClient) {
	}

	@OwnerMiddleware('userId')
	@Get()
	async getStorage(@Param('userId') owner: string): Promise<Storage> {
		try {
			return await this.storageClient.getStorage({ owner });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Post()
	async createStorage(@Param('userId') owner: string): Promise<Storage> {
		try {
			return await this.storageClient.createStorage({ owner });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Delete()
	async deleteStorage(@Param('userId') owner: string): Promise<void> {
		try {
			await this.storageClient.deleteStorage({ owner });
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}
}
