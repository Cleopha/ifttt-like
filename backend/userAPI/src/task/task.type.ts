export const TsTaskAction = {
	GITHUB_PR_OPEN: 'GITHUB_PR_OPEN',
	GITHUB_ISSUE_OPEN: 'GITHUB_ISSUE_OPEN',
	TIMER_DATE: 'TIMER_DATE',
	TIMER_INTERVAL: 'TIMER_INTERVAL',
	GOOGLE_NEW_CALENDAR_EVENT: 'GOOGLE_NEW_CALENDAR_EVENT',
	GOOGLE_NEW_DOC: 'GOOGLE_NEW_DOC',
	GOOGLE_NEW_SHEET: 'GOOGLE_NEW_SHEET'
};

export type TsTaskAction = (typeof TsTaskAction)[keyof typeof TsTaskAction]

export const TsTaskType = {
	ACTION: 'ACTION',
	REACTION: 'REACTION'
};

export type TsTaskType = (typeof TsTaskType)[keyof typeof TsTaskType]
