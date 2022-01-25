import { Module } from '@nestjs/common';

import { PrismaModule } from '@db';
import { AuthModule } from '@auth';

import { UserService } from './user.service';
import { UserController } from './user.controller';

@Module({
	imports: [ PrismaModule, AuthModule ],
	controllers: [ UserController ],
	providers: [ UserService ],
	exports: [ UserService ],
})
export class UserModule {}
