import { Module } from '@nestjs/common';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

import { PrismaService } from '@db';
import { UserService } from '@user';
import { ConfigService, IConfig } from '@config';

import { CredentialAPIClient } from './credentialAPI.client';
import { CredentialAPIStorageClient } from './credentialAPIStorage.client';
import { CredentialController } from './credential.controller';
import { StorageController } from './storage.controller';

@Module({
	providers: [
		UserService,
		PrismaService,
		CredentialAPIClient,
		CredentialAPIStorageClient,
		{
			provide: 'CREDENTIAL_PACKAGE',
			useFactory: (configService: ConfigService<IConfig>): ClientGrpcProxy => {
				const { host, port } = configService.get('credentialAPI');

				return ClientProxyFactory.create({
					transport: Transport.GRPC,
					options: {
						package: [ 'area.credential' ],
						protoPath: [ __dirname + '/../protos/credential.proto' ],
						url: `${ host }:${ port }`
					}
				});
			},
			inject: [ ConfigService ]
		}
	],
	controllers: [ CredentialController, StorageController ],
})
export class CredentialModule {
}
