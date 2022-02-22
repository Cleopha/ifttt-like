import { NullValue } from '@protos';

export interface IStruct {
	fields: { [key: string ]: IValue }
}

export type PrimitiveAllowedValue = null | number | string | boolean

export type AllowedValue = PrimitiveAllowedValue | AllowedObject | Array<AllowedValue>;

export type AllowedObject = { [key: string]: AllowedValue };

export interface IValue {
	/** Represents a null value. */
	nullValue?: NullValue;
	/** Represents a double value. */
	numberValue?: number;
	/** Represents a string value. */
	stringValue?: string;
	/** Represents a boolean value. */
	boolValue?: boolean;
	/** Represents a structured value. */
	structValue?: IStruct;
	/** Represents a repeated `Value`. */
	listValue?: Array<IValue>;
}
