import { ConfigModule } from '@nestjs/config';
import { DynamicModule } from '@nestjs/common';

import { config } from './config.data';

export const Config: DynamicModule = ConfigModule.forRoot({
	load: [ config ],
	isGlobal: true,
});