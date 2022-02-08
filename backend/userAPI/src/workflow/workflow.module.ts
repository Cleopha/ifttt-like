import { Module } from '@nestjs/common';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

import { IConfig, ConfigService } from '@config';
import { WorkflowController } from './workflow.controller';
import { WorkflowAPIClient } from './workflowAPI.client';
import { UserService } from '@user';
import { PrismaService } from '@db';

@Module({
	providers: [
		WorkflowAPIClient,
		UserService,
		PrismaService,
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
	controllers: [ WorkflowController ]
})
export class WorkflowModule {}
