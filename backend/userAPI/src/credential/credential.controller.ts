import {
	Body,
	Controller,
	Delete,
	Get,
	NotFoundException,
	Param,
	Post,
	Put,
	Query,
	UseInterceptors
} from '@nestjs/common';
import {
	ApiCreatedResponse,
	ApiInternalServerErrorResponse,
	ApiOkResponse,
	ApiOperation,
	ApiTags, ApiUnauthorizedResponse
} from '@nestjs/swagger';

import { OwnerMiddleware } from '@auth';
import { Credential } from '@protos';
import { Convertor } from '@util/convertor';

import { TsService } from './credential.type';
import { TransformCredentialInterceptor } from './credential.format';
import { CredentialAPIClient } from './client/credentialAPI.client';
import { CreateCredentialDto } from './dto/create-credential.dto';
import { UpdateCredentialDto } from './dto/update-credential.dto';
import { CredentialRo } from '@credential/ro/credential.ro';

@ApiTags('credentialAPI')
@Controller('/user/:userId/storage/credential')
@UseInterceptors(TransformCredentialInterceptor)
export class CredentialController {
	constructor(private credentialClient: CredentialAPIClient) {
	}

	@OwnerMiddleware('userId')
	@Get()
	@ApiOperation({ summary: 'Get a credential value of the provided service' })
	@ApiOkResponse({ type: CredentialRo })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async getCredential(@Param('userId') owner: string, @Query('service') service: TsService): Promise<Credential> {
		try {
			return await this.credentialClient.getCredential({
				owner,
				service: Convertor.tsServiceToGrpcService(service)
			});
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Post()
	@ApiOperation({ summary: 'Create a credential for the provided service' })
	@ApiCreatedResponse({ type: CredentialRo })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async createCredential(@Body() dto: CreateCredentialDto, @Param('userId') owner: string, @Query('service') service: TsService): Promise<Credential> {
		try {
			return await this.credentialClient.insertCredential({
					...dto,
					service: Convertor.tsServiceToGrpcService(service),
					owner,
				}
			);
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Put()
	@ApiOperation({ summary: 'Update token value of a credential' })
	@ApiOkResponse({ type: CredentialRo })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async updateCredential(@Body() dto: UpdateCredentialDto, @Param('userId') owner: string, @Query('service') service: TsService): Promise<Credential> {
		try {
			return await this.credentialClient.updateCredential({
					...dto,
					service: Convertor.tsServiceToGrpcService(service),
					owner,
				}
			);
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}

	@OwnerMiddleware('userId')
	@Delete()
	@ApiOperation({ summary: 'Delete a credential from the provided service' })
	@ApiOkResponse({ type: CredentialRo })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async deleteCredential(@Param('userId') owner: string, @Query('service') service: TsService): Promise<Credential> {
		try {
			return await this.credentialClient.removeCredential({
					service: Convertor.tsServiceToGrpcService(service),
					owner,
				}
			);
		} catch (e) {
			throw new NotFoundException(e.message);
		}
	}
}
