import { forwardRef, Module } from '@nestjs/common';


import { AuthController } from './auth.controller';
import { UserModule } from '@user';

@Module({
	imports: [ forwardRef(() => UserModule) ],
	controllers: [ AuthController ],
})
export class AuthModule {
}
