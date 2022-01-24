import * as ConnectRedis from 'connect-redis';
import * as session from 'express-session';
import { ConfigService } from '@nestjs/config';
import { RedisService } from 'nestjs-redis';
import { NestSessionOptions, SessionModule } from 'nestjs-session';

import { Redis } from './redis';
import { IConfig } from './app.config';

const RedisStore = ConnectRedis(session);

declare module 'express-session' {
	interface SessionData {
		user: {
			id: string;
		}
	}
}

export const Session = SessionModule.forRootAsync({
	imports: [Redis],
	inject: [RedisService, ConfigService],
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
					secure: false,
					sameSite: false,
					httpOnly: true,
					maxAge: 60000 * 60 * 6,
				},
			},
		};
	},
});
