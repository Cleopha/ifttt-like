import { ApiProperty } from '@nestjs/swagger';
import { TsTaskAction, TsTaskType } from '../task.type';

export class TaskRo {
	@ApiProperty({ description: 'Task unique identifier' })
	id: string;

	@ApiProperty()
	name?: string;

	@ApiProperty({ enum: [ 'ACTION', 'REACTION' ] })
	type: TsTaskType;

	@ApiProperty({
		enum: [ 'GITHUB_NEW_PR_DETECTED',
			'GITHUB_NEW_ISSUE_DETECTED',
			'GITHUB_NEW_ISSUE_ASSIGNATION_DETECTED',
			'GITHUB_NEW_ISSUE_CLOSED_DETECTED',
			'GOOGLE_NEW_INCOMING_EVENT',
			'SCALEWAY_VOLUME_EXCEEDS_LIMIT',
			'COINMARKETCAP_ASSET_VARIATION_DETECTED',
			'NIST_NEW_CVE_DETECTED',
			'GOOGLE_CREATE_NEW_EVENT',
			'GOOGLE_CREATE_NEW_DOCUMENT',
			'GOOGLE_CREATE_NEW_SHEET',
			'SCALEWAY_CREATE_NEW_FLEXIBLE_IP',
			'SCALEWAY_CREATE_NEW_INSTANCE',
			'SCALEWAY_CREATE_NEW_DATABASE',
			'SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER',
			'SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY',
			'ETH_SEND_TRANSACTION',
			'NOTION_CREATE_NEW_PAGE' ]
	})
	action: TsTaskAction;

	@ApiProperty({ description: 'Identifier of the next task' })
	nextTask: string;

	@ApiProperty({ description: 'Additional parameters required' })
	params?: { [key: string]: any };
}