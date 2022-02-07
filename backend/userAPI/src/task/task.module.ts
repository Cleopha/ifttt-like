import { Module } from '@nestjs/common';
import { ClientGrpcProxy, ClientProxyFactory, Transport } from '@nestjs/microservices';

import { IConfig, ConfigService } from '@config';

@Module({
	providers: [ {
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
	} ]
})
export class TaskModule {}
