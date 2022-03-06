import { Body, Controller, InternalServerErrorException, Post, Session } from '@nestjs/common';

import { CredentialAPIStorageClient } from '@credential/client/credentialAPIStorage.client';
import { CredentialAPIClient } from '@credential/client/credentialAPI.client';
import { UserService } from '@user';
import { ISession } from '@session';

import { LoginDto } from './dto/login.dto';
import { Convertor } from '@util/convertor';
import {
	ApiInternalServerErrorResponse,
	ApiOkResponse,
	ApiOperation,
	ApiTags,
} from '@nestjs/swagger';
import { hash } from 'bcrypt';

@ApiTags('user')
@Controller('oauth')
export class OauthController {
	constructor(
		private readonly storageClient: CredentialAPIStorageClient,
		private readonly credentialClient: CredentialAPIClient,
		private readonly userService: UserService
	) {
	}

	@Post('/login')
	@ApiOperation({ summary: 'Login user using OAuth2 and create a session' })
	@ApiOkResponse({ description: 'User successfully logged in' })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	async login(@Body() loginDto: LoginDto, @Session() session: ISession): Promise<string> {
		const { email, accessToken, type } = loginDto;

		let user = await this.userService.getByEmail(`${ email }-${ type }`);
		if (user) {
			try {
				await this.credentialClient.updateCredential({
					owner: user.id,
					service: Convertor.tsServiceToGrpcService(type),
					token: accessToken
				});
			} catch (e) {
				throw new InternalServerErrorException(e.msg);
			}

			session.user = { id: user.id };
			session.save();
			return 'User successfully logged in';
		}

		try {
			const hashedPassword = await hash(`${ email }-${ type }`, 10);
			user = await this.userService.create({
				email: `${ email }-${ type }`,
				password: hashedPassword,
			});

			// Create storage
			await this.storageClient.createStorage({
				owner: user.id
			});

			// Add service
			await this.credentialClient.insertCredential({
				owner: user.id,
				service: Convertor.tsServiceToGrpcService(type),
				token: accessToken
			});

			session.user = { id: user.id };
			session.save();

			return 'User successfully logged in';
		} catch (e) {
			throw new InternalServerErrorException(e.msg);
		}
	}
}