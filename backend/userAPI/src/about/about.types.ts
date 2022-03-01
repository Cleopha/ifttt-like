export interface IAboutClient {
	host: string;
}

// Reaction and Action
export interface IAboutTask {
	name: string;
	description: string;
}

export interface IAboutService {
	name: string;
	actions: IAboutTask[];
	reactions: IAboutTask[];
}

export interface IAboutServer {
	current_time: number;
	services: IAboutService[];
}

export interface IAbout {
	client: IAboutClient;
	server: IAboutServer;
}