import { Observable } from 'rxjs';
import { NullValue, Task, TaskAction, TaskType, Service, Credential } from '@protos';

import { AllowedObject, AllowedValue, IStruct, IValue, PrimitiveAllowedValue } from '@util/struct';
import { TsTaskAction, TsTaskType } from '@task';
import { TsService } from '@credential';


export class Convertor {
	static async extractFromObservable<T>(data: Observable<T>): Promise<T> {
		try {
			return await data.toPromise();
		} catch (e) {
			throw new Error(e.message);
		}
	}

	static grpcServiceToTsService(service: Service): TsService {
		const key = Object.keys(Service)[Object.values(Service).indexOf(service)];
		return (TsService as never)[key];
	}

	static tsServiceToGrpcService(service: TsService): Service {
		const key = Object.keys(TsService)[Object.values(TsService).indexOf(service)];
		return (Service as never)[key];
	}

	static formatGrpcCredentialToTypescript(credential: Credential): Credential {
		credential.service = this.grpcServiceToTsService(credential.service) as unknown as Service;
		return credential;
	}

	static grpcActionToTsAction(action: TaskAction): TsTaskAction {
		const key = Object.keys(TaskAction)[Object.values(TaskAction).indexOf(action)];
		return (TsTaskAction as never)[key];
	}

	static grpcTypeToTsType(action: TaskType): TsTaskType {
		const key = Object.keys(TaskType)[Object.values(TaskType).indexOf(action)];
		return (TsTaskType as never)[key];
	}

	static formatGrpcTaskToTypescript(task: Task): Task {
		task.params = this.grpcStructToObject(task.params as IStruct);
		task.type = this.grpcTypeToTsType(task.type) as unknown as TaskType;
		task.action = this.grpcActionToTsAction(task.action) as unknown as TaskAction;
		return task;
	}

	static getType(value: AllowedValue): string {
		const type = typeof value;

		// Check array
		if (Array.isArray(value)) {
			return 'array';
		}

		// Check null
		if (value == null) {
			return 'null';
		}

		return type;
	}

	static tsValueToIValue(value: AllowedValue): IValue {
		const convertor: Record<string, (v: AllowedValue) => IValue> = {
			'string': (v) => ({ stringValue: v as string }),
			'number': (v) => ({ numberValue: v as number }),
			'boolean': (v) => ({ boolValue: v as boolean }),
			'object': (v) => ({ structValue: this.objectToGrpcStruct(v as AllowedObject) }),
			'array': (v) => ({ listValue: (v as Array<PrimitiveAllowedValue>).map((t) => this.tsValueToIValue(t)) }),
			'null': (_) => ({ nullValue: NullValue.NULL_VALUE })
		};

		const type = this.getType(value);
		if (convertor[type] === undefined) {
			throw new Error(`Convertor: ${ type } not supported`);
		}
		return convertor[type](value);
	}

	static objectToGrpcStruct(obj: AllowedObject): IStruct {
		const keys = Object.keys(obj);
		const fields = {};

		keys.forEach((key) => {
			fields[key] = this.tsValueToIValue(obj[key]);
		});

		return { fields };
	}

	static iValueToTypescript(value: IValue): AllowedValue {
		const key = Object.keys(value);
		if (key.length != 1) {
			throw new Error(`Convertor: struct contains multiple keys`);

		}

		const convertor: Record<string, (v: IValue) => AllowedValue> = {
			'stringValue': (v) => v.stringValue,
			'numberValue': (v) => v.numberValue,
			'boolValue': (v) => v.boolValue,
			'structValue': (v) => (v.structValue != undefined && this.grpcStructToObject(v.structValue)),
			'listValue': (v) => (v.listValue as Array<IValue>).map((e) => this.iValueToTypescript(e)),
			'nullValue': (_) => null
		};

		return convertor[key[0]](value);
	}

	static grpcStructToObject(struct: IStruct): AllowedObject {
		const keys = Object.keys(struct.fields);
		const obj: AllowedObject = {};

		keys.forEach((key) => {
			obj[key] = this.iValueToTypescript(struct.fields[key]);
		});
		return obj;
	}
}