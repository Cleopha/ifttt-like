import { Module } from '@nestjs/common';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

import { IConfig, ConfigService } from '@config';
import { TaskAPIClient } from './taskAPI.client';
import { UserService } from '@user/user.service';
import { PrismaService } from '@db';
import { TaskController } from './task.controller';
import { WorkflowModule } from '@workflow';
import { TaskOwnerController } from './taskOwner.controller';

@Module({
	imports: [ WorkflowModule ],
	providers: [
		TaskAPIClient,
		UserService,
		PrismaService,
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
	controllers: [ TaskController, TaskOwnerController ]
})
export class TaskModule {
}
