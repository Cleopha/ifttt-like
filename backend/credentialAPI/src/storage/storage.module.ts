import { Module } from '@nestjs/common';

import { PrismaModule } from '@db';
import { CredentialModule } from '@credential';

import { StorageController } from './storage.controller';
import { StorageService } from './storage.service';

@Module({
	imports: [ PrismaModule, CredentialModule ],
	controllers: [ StorageController ],
	providers: [ StorageService ],
})
export class StorageModule {}
