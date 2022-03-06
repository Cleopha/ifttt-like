import { get, IOptionalVariable } from 'env-var';

const env = (name: string, required = true): IOptionalVariable => get(name).required(required);

const api = {
	host: env('API_HOST').asString(),
	port: env('API_PORT').asPortNumber(),
	session: {
		secret: env('API_SESSION_SECRET').asString(),
		maxAge: env('API_SESSION_MAX_AGE').asInt(),
		secure: env('API_SESSION_SECURE').asBool()
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

const workflowAPI = {
	host: env('WORKFLOW_API_HOST').asString(),
	port: env('WORKFLOW_API_PORT').asPortNumber(),
}

const credentialAPI = {
	host: env('CREDENTIAL_API_HOST').asString(),
	port: env('CREDENTIAL_API_PORT').asPortNumber(),

}

// Config types
export type IApiConfig = typeof api;
export type IDBConfig = typeof db;
export type IRedisConfig = typeof redis;
export type IWorkflowAPIConfig =  typeof workflowAPI;
export type ICredentialAPIConfig = typeof credentialAPI;
export interface IConfig {
	api: IApiConfig;
	db: IDBConfig;
	redis: IRedisConfig;
	workflowAPI: IWorkflowAPIConfig;
	credentialAPI: ICredentialAPIConfig;
}

export const config = (): IConfig => ({
	api,
	db,
	redis,
	workflowAPI,
	credentialAPI,
});
