import { Module } from '@nestjs/common';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

import { IConfig, ConfigService } from '@config';
import { WorkflowController } from './workflow.controller';
import { WorkflowAPIClient } from './workflowAPI.client';
import { UserModule } from '@user';
import { AuthModule } from '@auth';

@Module({
	imports: [ UserModule, AuthModule ],
	providers: [
		WorkflowAPIClient,
		{
			provide: 'WORKFLOW_PACKAGE',
			useFactory: (configService: ConfigService<IConfig>): ClientGrpcProxy => {
				const { host, port } = configService.get('workflowAPI');

				return ClientProxyFactory.create({
					transport: Transport.GRPC,
					options: {
						package: [ 'area.workflow', 'area.task' ],
						protoPath: [ __dirname + '/../protos/task.proto', __dirname + '/../protos/workflow.proto' ],
						url: `${ host }:${ port }`
					}
				});
			},
			inject: [ ConfigService ]
		}
	],
	controllers: [ WorkflowController ],
	exports: [ WorkflowAPIClient ],
})
export class WorkflowModule {}
