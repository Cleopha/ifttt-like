import { DocumentBuilder } from '@nestjs/swagger';

export default new DocumentBuilder()
	.setTitle('Area API')
	.setDescription('Area API to manage users and their workflows')
	.setVersion('1.0')
	.addTag('user', 'CRUD endpoints with authentication management')
	.addTag('workflowAPI', 'A gateway to internal microservices to manage workflow and tasks')
	.build();
