import { Module } from '@nestjs/common';

import { Config as ConfigModule } from '@config';
import { PrismaModule } from '@db';
import { CredentialModule } from '@credential';
import { StorageModule } from '@storage';

@Module({
	imports: [ ConfigModule, PrismaModule, CredentialModule, StorageModule ],
})
export class AppModule {}
