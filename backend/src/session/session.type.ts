import { Session } from 'express-session';

// Session data
export interface ISession extends Session {
		user: {
			id: string
		}
}