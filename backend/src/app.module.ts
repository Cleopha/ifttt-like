import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { UserModule } from './user';
import { AuthModule } from './auth';
import { PrismaModule } from './prisma';

import { config } from './app.config';

@Module({
	imports: [
		UserModule,
		ConfigModule.forRoot({
			load: [config],
			isGlobal: true,
		}),
		AuthModule,
		PrismaModule,
	],
})
export class AppModule {}
