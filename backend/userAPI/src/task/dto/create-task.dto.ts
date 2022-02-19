import { IsEnum, IsObject, IsString } from 'class-validator';

export enum TaskType {
	ACTION = 'ACTION',
	REACTION = 'REACTION',
}

export enum TaskAction {
	GITHUB_PR_OPEN = 'GITHUB_PR_OPEN',
	GITHUB_ISSUE_OPEN = 'GITHUB_ISSUE_OPEN',
	TIMER_DATE = 'TIMER_DATE',
	TIMER_INTERVAL = 'TIMER_INTERVAL',
	GOOGLE_CALENDAR_NEW_EVENT = 'GOOGLE_CALENDAR_NEW_EVENT',
	GOOGLE_NEW_DOC = 'GOOGLE_NEW_DOC',
	GOOGLE_NEW_SHEET = 'GOOGLE_NEW_SHEET'
}

export type Param = { [key: string]: any };

export class CreateTaskDto {
	@IsString()
	name: string;

	@IsEnum(TaskType)
	type: TaskType;

	@IsEnum(TaskAction)
	action: TaskAction;

	@IsString()
	nextTask: string;

	@IsObject()
	params: Param;
}