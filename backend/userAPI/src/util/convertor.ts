import { Observable } from 'rxjs';

export class Convertor {
	static async extractFromObservable<T>(data: Observable<T>): Promise<T> {
		try {
			return await data.toPromise();
		} catch (e) {
			throw new Error(e.message)
		}
	}
}