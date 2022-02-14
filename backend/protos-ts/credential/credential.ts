/* eslint-disable */
import { GrpcMethod, GrpcStreamMethod } from "@nestjs/microservices";
import { util, configure } from "protobufjs/minimal";
import * as Long from "long";
import { Observable } from "rxjs";
import { Metadata } from "@grpc/grpc-js";
import { Empty } from "./google/protobuf/empty";
import { IsEnum, IsOptional, IsString } from 'class-validator';

export const protobufPackage = "area.credential";

export enum Service {
  GITHUB = 0,
  GOOGLE = 1,
  SCALEWAY = 2,
  COIN_MARKET = 3,
  DOCKER = 4,
  ONE_DRIVE = 5,
  NOTION = 6,
  UNRECOGNIZED = -1,
}

/** Storage is a box that store any kind of credential */
export interface Storage {
  owner: string;
  credentials: Credential[];
}

/** Credential is a key/value store */
export interface Credential {
  service: Service;
  token: string;
}

export class CreateStorageRequest {
  @IsString()
  owner: string;
}

export class DeleteStorageRequest {
  @IsString()
  owner: string;
}

export class InsertCredentialRequest {
  @IsString()
  owner: string;

  @IsEnum(Service)
  service: Service;

  @IsString()
  token: string;
}

export class GetCredentialRequest {
  @IsString()
  owner: string;

  @IsEnum(Service)
  service: Service;
}

export class UpdateCredentialRequest {
  @IsString()
  @IsOptional()
  owner: string;

  @IsEnum(Service)
  @IsOptional()
  service: Service;

  @IsString()
  @IsOptional()
  token: string;
}

export class RemoveCredentialRequest {
  @IsString()
  owner: string;

  @IsEnum(Service)
  service: Service;
}

export const AREA_CREDENTIAL_PACKAGE_NAME = "area.credential";

/** Manage credentials */

export interface CredentialServiceClient {
  createStorage(
    request: CreateStorageRequest,
    metadata?: Metadata
  ): Observable<Storage>;

  deleteStorage(
    request: DeleteStorageRequest,
    metadata?: Metadata
  ): Observable<Empty>;

  insertCredential(
    request: InsertCredentialRequest,
    metadata?: Metadata
  ): Observable<Storage>;

  getCredential(
    request: GetCredentialRequest,
    metadata?: Metadata
  ): Observable<Credential>;

  updateCredential(
    request: UpdateCredentialRequest,
    metadata?: Metadata
  ): Observable<Credential>;

  removeCredential(
    request: RemoveCredentialRequest,
    metadata?: Metadata
  ): Observable<Storage>;
}

/** Manage credentials */

export interface CredentialServiceController {
  createStorage(
    request: CreateStorageRequest,
    metadata?: Metadata
  ): Promise<Storage> | Observable<Storage> | Storage;

  deleteStorage(request: DeleteStorageRequest, metadata?: Metadata): void;

  insertCredential(
    request: InsertCredentialRequest,
    metadata?: Metadata
  ): Promise<Storage> | Observable<Storage> | Storage;

  getCredential(
    request: GetCredentialRequest,
    metadata?: Metadata
  ): Promise<Credential> | Observable<Credential> | Credential;

  updateCredential(
    request: UpdateCredentialRequest,
    metadata?: Metadata
  ): Promise<Credential> | Observable<Credential> | Credential;

  removeCredential(
    request: RemoveCredentialRequest,
    metadata?: Metadata
  ): Promise<Storage> | Observable<Storage> | Storage;
}

export function CredentialServiceControllerMethods() {
  return function (constructor: Function) {
    const grpcMethods: string[] = [
      "createStorage",
      "deleteStorage",
      "insertCredential",
      "getCredential",
      "updateCredential",
      "removeCredential",
    ];
    for (const method of grpcMethods) {
      const descriptor: any = Reflect.getOwnPropertyDescriptor(
        constructor.prototype,
        method
      );
      GrpcMethod("CredentialService", method)(
        constructor.prototype[method],
        method,
        descriptor
      );
    }
    const grpcStreamMethods: string[] = [];
    for (const method of grpcStreamMethods) {
      const descriptor: any = Reflect.getOwnPropertyDescriptor(
        constructor.prototype,
        method
      );
      GrpcStreamMethod("CredentialService", method)(
        constructor.prototype[method],
        method,
        descriptor
      );
    }
  };
}

export const CREDENTIAL_SERVICE_NAME = "CredentialService";

// If you get a compile-error about 'Constructor<Long> and ... have no overlap',
// add '--ts_proto_opt=esModuleInterop=true' as a flag when calling 'protoc'.
if (util.Long !== Long) {
  util.Long = Long as any;
  configure();
}
