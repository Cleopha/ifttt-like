import { forwardRef, Module } from '@nestjs/common';

import { UserModule } from '@user';

import { AuthController } from './auth.controller';
import { AuthGuard } from './auth.guard';
import { OwnerGuard } from './owner.guard';

@Module({
	imports: [ forwardRef(() => UserModule) ],
	controllers: [ AuthController ],
	providers: [ AuthGuard, OwnerGuard ],
	exports: [ AuthGuard ]
})
export class AuthModule {
}
