export const TsTaskAction = {
	GITHUB_PR_MERGE: 'GITHUB_PR_MERGE',
	GITHUB_ISSUE_CLOSE: 'GITHUB_ISSUE_CLOSE',
	TIMER_DATE: 'TIMER_DATE',
	TIMER_INTERVAL: 'TIMER_INTERVAL'
};

export type TsTaskAction = (typeof TsTaskAction)[keyof typeof TsTaskAction]

export const TsTaskType = {
	ACTION: 'ACTION',
	REACTION: 'REACTION'
};

export type TsTaskType = (typeof TsTaskType)[keyof typeof TsTaskType]
