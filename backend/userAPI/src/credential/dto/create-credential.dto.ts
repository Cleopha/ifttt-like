import { IsString } from 'class-validator';

export class CreateCredentialDto {
	@IsString()
	token: string;
}