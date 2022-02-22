import { get, IOptionalVariable } from 'env-var';

const env = (name: string, required = true): IOptionalVariable => get(name).required(required);

const api = {
	host: env('API_HOST').asString(),
	port: env('API_PORT').asPortNumber(),
};

const db = {
	url: env('DB_URL').asString(),
};

// Types
export type IApiConfig = typeof api;
export type IDBConfig = typeof db;

export interface IConfig {
	api: IApiConfig;
	db: IDBConfig;
}

export const config = (): IConfig => ({
	api,
	db,
});