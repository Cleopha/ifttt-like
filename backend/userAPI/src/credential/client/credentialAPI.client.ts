import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientGrpc } from '@nestjs/microservices';

import {
	CredentialServiceClient,
	GetCredentialRequest,
	InsertCredentialRequest,
	RemoveCredentialRequest,
	UpdateCredentialRequest,
	Credential
} from '@protos';
import { Convertor } from '@util/convertor';

@Injectable()
export class CredentialAPIClient implements OnModuleInit {
	private credentialService: CredentialServiceClient;

	constructor(@Inject('CREDENTIAL_PACKAGE') private client: ClientGrpc) {
	}

	onModuleInit(): void {
		this.credentialService = this.client.getService<CredentialServiceClient>('CredentialService');
	}

	async getCredential(req: GetCredentialRequest): Promise<Credential> {
		const res = this.credentialService.getCredential(req);
		return Convertor.extractFromObservable(res);
	}

	async insertCredential(req: InsertCredentialRequest): Promise<Credential> {
		const res = this.credentialService.insertCredential(req);
		return Convertor.extractFromObservable(res);
	}

	async updateCredential(req: UpdateCredentialRequest): Promise<Credential> {
		const res = this.credentialService.updateCredential(req);
		return Convertor.extractFromObservable(res);
	}

	async removeCredential(req: RemoveCredentialRequest): Promise<Credential> {
		const res = this.credentialService.removeCredential(req);
		return Convertor.extractFromObservable(res);
	}
}