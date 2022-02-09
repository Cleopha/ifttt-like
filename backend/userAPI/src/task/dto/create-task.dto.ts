import { IsEnum, IsObject, IsString } from 'class-validator';

export enum TaskType {
	ACTION = 'ACTION',
	REACTION = 'REACTION',
}

export enum TaskAction {
	GITHUB_PR_MERGE = 'GITHUB_PR_MERGE',
	GITHUB_ISSUE_CLOSE = 'GITHUB_ISSUE_CLOSE',
	TIMER_DATE = 'TIMER_DATE',
	TIMER_INTERVAL = 'TIMER_INTERVAL',
}

export type Param = { [key: string]: any };

export class CreateTaskDto {
	@IsString()
	name: string;

	@IsEnum(TaskType)
	type: TaskType;

	@IsEnum(TaskAction)
	action: TaskAction

	@IsString()
	nextTask: string;

	@IsObject()
	params: Param
}