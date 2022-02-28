import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientGrpc } from '@nestjs/microservices';

import {
	CreateStorageRequest,
	DeleteStorageRequest,
	Empty,
	GetStorageRequest,
	Storage,
	StorageServiceClient
} from '@protos';
import { Convertor } from '@util/convertor';

@Injectable()
export class CredentialAPIStorageClient implements OnModuleInit {
	private storageService: StorageServiceClient;

	constructor(@Inject('CREDENTIAL_PACKAGE') private client: ClientGrpc) {
	}

	onModuleInit(): void {
		this.storageService = this.client.getService<StorageServiceClient>('StorageService');
	}

	async createStorage(req: CreateStorageRequest): Promise<Storage> {
		const res = this.storageService.createStorage(req);
		return Convertor.extractFromObservable(res);
	}

	async getStorage(req: GetStorageRequest): Promise<Storage | undefined> {
		const res = this.storageService.getStorage(req);
		return Convertor.extractFromObservable(res);
	}

	async deleteStorage(req: DeleteStorageRequest): Promise<Empty> {
		const res = this.storageService.deleteStorage(req);
		return Convertor.extractFromObservable(res);
	}
}