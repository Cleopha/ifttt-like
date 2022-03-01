import { Controller, Post, Session } from '@nestjs/common';
import { CredentialAPIStorageClient } from '@credential/client/credentialAPIStorage.client';
import { UserService } from '@user';
import { ISession } from '@session';

@Controller('oauth')
export class OauthController {
	constructor(
		private readonly storageClient: CredentialAPIStorageClient,
		private readonly userService: UserService
	) {}

	@Post('/login')
	async login(@Session() session: ISession): Promise<string> {
		return 'TODO'
	}
}