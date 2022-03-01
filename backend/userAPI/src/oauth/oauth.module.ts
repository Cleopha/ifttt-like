import { Module } from '@nestjs/common';
import { CredentialAPIClientModule } from '@credential/client/credentialAPIClient.module';
import { OauthController } from './oauth.controller';
import { UserModule } from '@user';

@Module({
	imports: [ UserModule, CredentialAPIClientModule ],
	controllers: [ OauthController ],
})
export class OauthModule {
}