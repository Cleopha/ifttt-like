import { IsOptional, IsString } from 'class-validator';

export class UpdateWorkflowDto {
	@IsString()
	@IsOptional()
	name?: string;
}