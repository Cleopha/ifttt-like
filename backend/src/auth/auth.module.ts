import { Module } from '@nestjs/common';

import { UserModule } from '../user';
import { AuthController } from './auth.controller';

@Module({
	imports: [UserModule],
	controllers: [AuthController],
})
export class AuthModule {}
