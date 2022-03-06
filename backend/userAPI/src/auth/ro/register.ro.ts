import { Role } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

export class UserRO {
	@ApiProperty()
	id: string

	@ApiProperty()
	email: string

	@ApiProperty()
	password: string

	@ApiProperty({ enum: Role })
	role: Role
}