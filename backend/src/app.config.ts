import { get } from 'env-var';

const env = (name: string, required = true) => get(name).required(required);

const api = {
	host: env('API_HOST').asString(),
	port: env('API_PORT').asPortNumber(),
};

const db = {
	url: env('DB_URL').asString(),
};

const redis = {
	host: env('REDIS_HOST').asString(),
	port: env('REDIS_PORT').asPortNumber(),
	pass: env('REDIS_PASS').asString(),
};

export interface IConfig {
	api: typeof api;
	db: typeof db;
	redis: typeof redis;
}

export const config = (): IConfig => ({
	api,
	db,
	redis,
});
