import { Injectable } from '@nestjs/common';
import { IAboutService } from './about.types';

@Injectable()
export class AboutService {
	githubService(): IAboutService {
		return {
			name: 'github',
			actions: [
				{
					name: 'new_pr_detected',
					description: 'A new pull request is open on GitHub repository'
				},
				{
					name: 'new_issue_detected',
					description: 'A new issue is open on GitHub repository'
				},
				{
					name: 'new_issue_assignation_detected',
					description: 'A new assignation on issue in detected on GitHub repository'
				},
				{
					name: 'new_issue_closed_detected',
					description: 'An issue is closed on GitHub repository'
				}
			],
			reactions: []
		};
	}

	scalewayService(): IAboutService {
		return {
			name: 'scaleway',
			actions: [
				{
					name: 'volume_exceeds_limit',
					description: 'Detect a volume that exceeds given limit'
				}
			],
			reactions: [
				{
					name: 'create_new_flexible_ip',
					description: 'Create a flexible ip on Scaleway'
				},
				{
					name: 'create_new_instance',
					description: 'Create a new instance on Scaleway'
				},
				{
					name: 'create_new_database',
					description: 'Create a new database on Scaleway'
				},
				{
					name: 'create_new_kubernetes_cluster',
					description: 'Create a new Kubernetes cluster on Scaleway'
				},
				{
					name: 'create_new_container_registry',
					description: 'Create a new container registry on Scaleway'
				},
			],
		};
	}

	googleService(): IAboutService {
		return {
			name: 'google',
			actions: [
				{
					name: 'new_incoming_event',
					description: 'Detect an event on Google Calendar'
				},
			],
			reactions: [
				{
					name: 'create_new_event',
					description: 'Create an event on Google Calendar'
				},
				{
					name: 'create_new_document',
					description: 'Create a document on Google Drive'
				},
				{
					name: 'create_new_sheet',
					description: 'Create a spreadsheet on Google Drive'
				},
			]
		};
	}

	coinMarketCapService(): IAboutService {
		return {
			name: 'coin_market_cap',
			actions: [
				{
					name: 'asset_variation_detected',
					description: 'Detect a change on assets'
				},
			],
			reactions: [],
		};
	}

	nistService(): IAboutService {
		return {
			name: 'nist',
			actions: [
				{
					name: 'new_cve_detected',
					description: 'Detect a CVE on NIST website'
				},
			],
			reactions: [],
		};
	}

	ethService(): IAboutService {
		return {
			name: 'eth',
			actions: [],
			reactions: [
				{
					name: 'send_transaction',
					description: 'Send a transaction to Ethereum blockchain'
				},
			],
		};
	}

	notionService(): IAboutService {
		return {
			name: 'notion',
			actions: [],
			reactions: [
				{
					name: 'create_new_page',
					description: 'Create a new page on Notion'
				},
			],
		};
	}
}
