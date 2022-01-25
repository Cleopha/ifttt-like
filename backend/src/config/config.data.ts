import { get, IOptionalVariable } from 'env-var';

const env = (name: string, required = true): IOptionalVariable => get(name).required(required);


const api = {
	host: env('API_HOST').asString(),
	port: env('API_PORT').asPortNumber(),
	session: {
		secret: env('API_SESSION_SECRET').asString()
	}
};

const db = {
	url: env('DB_URL').asString(),
};

const redis = {
	host: env('REDIS_HOST').asString(),
	port: env('REDIS_PORT').asPortNumber(),
	pass: env('REDIS_PASS').asString(),
};

// Config types
export type IApiConfig = typeof api;
export type IDBConfig = typeof db;
export type IRedisConfig = typeof redis;
export interface IConfig {
	api: IApiConfig;
	db: IDBConfig;
	redis: IRedisConfig;
}

export const config = (): IConfig => ({
	api,
	db,
	redis,
});
