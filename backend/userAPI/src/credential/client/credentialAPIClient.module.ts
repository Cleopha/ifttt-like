import { Module } from '@nestjs/common';
import { CredentialAPIClient } from './credentialAPI.client';
import { CredentialAPIStorageClient } from './credentialAPIStorage.client';
import { ConfigService, IConfig } from '@config';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

@Module({
	providers: [
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
						protoPath: [ __dirname + '/../../protos/credential.proto' ],
						url: `${ host }:${ port }`
					}
				});
			},
			inject: [ ConfigService ]
		}
	],
	exports: [ CredentialAPIClient, CredentialAPIStorageClient ]
})
export class CredentialAPIClientModule {
}