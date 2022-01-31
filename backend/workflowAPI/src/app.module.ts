import { Module } from '@nestjs/common';
import { Config as ConfigModule } from './config';
import { PrismaModule } from './prisma';

@Module({
	imports: [ ConfigModule, PrismaModule ],
})
export class AppModule {
}
