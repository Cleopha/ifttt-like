import { TsService } from '@credential/credential.type';
import { ApiProperty } from '@nestjs/swagger';

export class CredentialRo {
	@ApiProperty({ enum: TsService })
	service: TsService;

	@ApiProperty({ description: 'value' })
	token: string;
}