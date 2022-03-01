import { Module } from '@nestjs/common';

import { PrismaModule } from '@db';

import { StorageController } from './storage.controller';
import { CredentialAPIClientModule } from './client/credentialAPIClient.module';
import { UserModule } from '@user';
import { CredentialController } from './credential.controller';

@Module({
	imports: [ PrismaModule, UserModule, CredentialAPIClientModule ],
	controllers: [ StorageController, CredentialController ],
})
export class CredentialModule {
}
