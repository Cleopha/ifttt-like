import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { UserModule } from './user';
import { AuthModule } from './auth';
import { PrismaModule } from './prisma';

import { config } from './app.config';
import { Session as SessionModule } from './app.session';

@Module({
	imports: [
		UserModule,
		ConfigModule.forRoot({
			load: [config],
			isGlobal: true,
		}),
		AuthModule,
		PrismaModule,
		SessionModule,
	],
})
export class AppModule {}
