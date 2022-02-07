import { Observable } from 'rxjs';

export class Convertor {
	static async extractFromObservable<T>(data: Observable<T>): Promise<T> {
		return new Promise((resolve) => {
			data.subscribe((value) => resolve(value));
		});
	}
}