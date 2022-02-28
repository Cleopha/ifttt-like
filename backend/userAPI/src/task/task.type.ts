export const TsTaskAction = {
	GITHUB_NEW_PR_DETECTED: 'GITHUB_NEW_PR_DETECTED',
	GITHUB_NEW_ISSUE_DETECTED: 'GITHUB_NEW_ISSUE_DETECTED',
	GITHUB_NEW_ISSUE_ASSIGNATION_DETECTED: 'GITHUB_NEW_ISSUE_ASSIGNATION_DETECTED',
	GITHUB_NEW_ISSUE_CLOSED_DETECTED: 'GITHUB_NEW_ISSUE_CLOSED_DETECTED',
	GOOGLE_NEW_INCOMING_EVENT: 'GOOGLE_NEW_INCOMING_EVENT',
	SCALEWAY_VOLUME_EXCEEDS_LIMIT: 'SCALEWAY_VOLUME_EXCEEDS_LIMIT',
	COINMARKETCAP_ASSET_VARIATION_DETECTED: 'COINMARKETCAP_ASSET_VARIATION_DETECTED',
	NIST_NEW_CVE_DETECTED: 'NIST_NEW_CVE_DETECTED',
	GOOGLE_CREATE_NEW_EVENT: 'GOOGLE_CREATE_NEW_EVENT',
	GOOGLE_CREATE_NEW_DOCUMENT: 'GOOGLE_CREATE_NEW_DOCUMENT',
	GOOGLE_CREATE_NEW_SHEET: 'GOOGLE_CREATE_NEW_SHEET',
	SCALEWAY_CREATE_NEW_FLEXIBLE_IP: 'SCALEWAY_CREATE_NEW_FLEXIBLE_IP',
	SCALEWAY_CREATE_NEW_INSTANCE: 'SCALEWAY_CREATE_NEW_INSTANCE',
	SCALEWAY_CREATE_NEW_DATABASE: 'SCALEWAY_CREATE_NEW_DATABASE',
	SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER: 'SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER',
	SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY: 'SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY',
	ETH_SEND_TRANSACTION: 'ETH_SEND_TRANSACTION',
	NOTION_CREATE_NEW_PAGE: 'NOTION_CREATE_NEW_PAGE',
};

export type TsTaskAction = (typeof TsTaskAction)[keyof typeof TsTaskAction]

export const TsTaskType = {
	ACTION: 'ACTION',
	REACTION: 'REACTION'
};

export type TsTaskType = (typeof TsTaskType)[keyof typeof TsTaskType]
