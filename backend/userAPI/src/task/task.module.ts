import { Module } from '@nestjs/common';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

import { IConfig, ConfigService } from '@config';
import { TaskAPIClient } from './taskAPI.client';
import { TaskController } from './task.controller';
import { WorkflowModule } from '@workflow';
import { UserModule } from '@user';

@Module({
	imports: [ UserModule, WorkflowModule ],
	providers: [
		TaskAPIClient,
		{
			provide: 'TASK_PACKAGE',
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
		} ],
	controllers: [ TaskController ]
})
export class TaskModule {
}
