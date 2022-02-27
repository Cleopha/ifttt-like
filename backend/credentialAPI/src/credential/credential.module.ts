import { Module } from '@nestjs/common';

import { PrismaModule } from '@db';

import { CredentialService } from './credential.service';
import { CredentialController } from './credential.controller';
import { CredentialConvertor } from './credential.convertor';

@Module({
	imports: [ PrismaModule ],
	providers: [ CredentialService, CredentialConvertor ],
	controllers: [ CredentialController ],
	exports: [ CredentialConvertor ]
})
export class CredentialModule {}
