import { IsEmail, IsEnum, IsString } from 'class-validator';
import { TsService } from '@credential/credential.type';

export class LoginDto {
	@IsEmail()
	email: string;

	@IsString()
	accessToken: string;

	@IsEnum(TsService)
	type: TsService
}