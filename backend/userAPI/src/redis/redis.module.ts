import { DynamicModule } from '@nestjs/common';

import { RedisModule, RedisModuleOptions } from 'nestjs-redis';

import { IConfig, IRedisConfig, ConfigService } from '@config';


export const Redis: DynamicModule = RedisModule.forRootAsync({
	inject: [ ConfigService ],
	useFactory: (config: ConfigService<IConfig>): RedisModuleOptions => {
		const { host, port, pass: password } = config.get<IRedisConfig>('redis');

		return {
			host,
			port,
			password,
		};
	},
});
