import * as ConnectRedis from 'connect-redis';
import * as session from 'express-session';
import { NestSessionOptions, SessionModule } from 'nestjs-session';

import { IConfig, ConfigService } from '@config';
import { Redis, RedisService } from '@redis';

const RedisStore = ConnectRedis(session);

export const Session = SessionModule.forRootAsync({
	imports: [ Redis ],
	inject: [ RedisService, ConfigService ],
	useFactory: (redisService: RedisService, config: ConfigService<IConfig>): NestSessionOptions => {
		const redisClient = redisService.getClient();
		const store = new RedisStore({ client: redisClient, logErrors: true });
		return {
			session: {
				store,
				secret: config.get<string>('api.session.secret' as keyof IConfig),
				resave: true,
				saveUninitialized: true,
				cookie: {
					secure: config.get<boolean>('api.session.secure' as keyof IConfig),
					sameSite: false,
					httpOnly: true,
					maxAge: config.get<number>('api.session.maxAge' as keyof IConfig),
				},
			},
		};
	},
});
