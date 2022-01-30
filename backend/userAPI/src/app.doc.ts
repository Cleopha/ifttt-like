import { DocumentBuilder } from '@nestjs/swagger';

export default new DocumentBuilder()
	.setTitle('Area API')
	.setDescription('Area API to manage users and their workflows')
	.setVersion('1.0')
	.addTag('user', 'User tag')
	.build();
