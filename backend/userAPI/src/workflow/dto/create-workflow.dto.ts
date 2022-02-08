import { IsString } from 'class-validator';

export class CreateWorkflowDto {
	@IsString()
	name: string;
}