import { Controller, UseFilters, UseInterceptors, ValidationPipe } from '@nestjs/common';
import { Payload, RpcException } from '@nestjs/microservices';

import {
	CredentialServiceController, CredentialServiceControllerMethods,
	GetCredentialRequest,
	InsertCredentialRequest, RemoveCredentialRequest, UpdateCredentialRequest, Credential
} from '@protos';
import { LoggingInterceptor } from '@logger';
import { RpcExceptionInterceptor } from '@exception';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime';

import { CredentialConvertor } from './credential.convertor';
import { CredentialService } from './credential.service';

@Controller()
@UseInterceptors(new LoggingInterceptor())
@CredentialServiceControllerMethods()
export class CredentialController implements CredentialServiceController {
	constructor(private credentialService: CredentialService, private credentialConvertor: CredentialConvertor) {
	}

	@UseFilters(new RpcExceptionInterceptor)
	async getCredential(@Payload(new ValidationPipe({ whitelist: true })) req: GetCredentialRequest): Promise<Credential> {
		const { service, owner } = req;

		try {
			const credential = await this.credentialService.getCredential(
				this.credentialConvertor.grpcServiceToPrismaService(service), owner);
			if (!credential) {
				throw new RpcException('Credential not found');
			}
			return this.credentialConvertor.prismaCredentialToGrpcCredential(credential);
		} catch (e) {
			throw new RpcException(e.message);
		}
	}

	@UseFilters(new RpcExceptionInterceptor)
	async insertCredential(@Payload(new ValidationPipe({ whitelist: true })) req: InsertCredentialRequest): Promise<Credential> {
		const { service, owner, token } = req;

		try {
			const isExist = await this.credentialService.getCredential(
				this.credentialConvertor.grpcServiceToPrismaService(service), owner);
			if (isExist) {
				throw new RpcException(`Credential for service ${service} already exist`)
			}

			const credential = await this.credentialService.createCredential({
				service: this.credentialConvertor.grpcServiceToPrismaService(service),
				token,
			}, owner);
			return this.credentialConvertor.prismaCredentialToGrpcCredential(credential);
		} catch (e) {
			throw new RpcException(e.message);
		}
	}

	@UseFilters(new RpcExceptionInterceptor)
	async removeCredential(@Payload(new ValidationPipe({ whitelist: true })) req: RemoveCredentialRequest): Promise<Credential> {
		const { service, owner } = req;

		try {
			const credential = await this.credentialService.deleteCredential(
				this.credentialConvertor.grpcServiceToPrismaService(service), owner);
			return this.credentialConvertor.prismaCredentialToGrpcCredential(credential);
		} catch (e) {
			if (e instanceof PrismaClientKnownRequestError) {
				if (e.code == 'P2025') {
					throw new RpcException('Credential not found');
				}
			}
			throw new RpcException(e.message);
		}
	}

	@UseFilters(new RpcExceptionInterceptor())
	async updateCredential(@Payload(new ValidationPipe(({ whitelist: true }))) req: UpdateCredentialRequest): Promise<Credential> {
		const { service, owner, token } = req;

		try {
			const credential = await this.credentialService.updateCredential(
				this.credentialConvertor.grpcServiceToPrismaService(service), owner, token);
			return this.credentialConvertor.prismaCredentialToGrpcCredential(credential);
		} catch (e) {
			throw new RpcException(e.message);
		}
	}
}
