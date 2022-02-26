import { Workflow, Prisma, PrismaClient, TaskAction, TaskType } from '@prisma/client';

const prisma = new PrismaClient();

async function createWorkflows(): Promise<Workflow[]> {
	const workflows: Prisma.WorkflowCreateInput[] = [
		{ name: 'Workflow 1', owner: 'f1352b9d-3a91-496e-9179-ae9e32429d9a' },
		{ name: 'Workflow 2', owner: '49eb7f7f-e3c8-4ed4-8078-bed29c1cf135' },
	];

	return Promise.all(workflows.map((w) => prisma.workflow.create({ data: w })));
}

async function createTasks(workflows: Workflow[]): Promise<void> {
	// Seed workflow 1
	{
		const t3 = await prisma.task.create({
			data: {
				name: 'Reaction - Google create new document',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_DOCUMENT,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'title': {
							'stringValue': 'This is a document'
						},
					}
				},
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t2 = await prisma.task.create({
			data: {
				name: 'Reaction - Google create new event',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_EVENT,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'title': {
							'stringValue': 'This is a new event'
						},
						'start': {
							'stringValue': '2022-02-26T20:00:00+01:00'
						},
						'duration': {
							'stringValue': '2h0m0s'
						},
					}
				},
				nextTask: t3.id,
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t1 = await prisma.task.create({
			data: {
				name: 'Action - When a new GitHub issue is open',
				type: TaskType.ACTION,
				action: TaskAction.GITHUB_NEW_ISSUE_DETECTED,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'repo': {
							'stringValue': 'ifttt-like-test'
						},
						'user': {
							'stringValue': 'Cleopha'
						},
						'state': {
							'stringValue': 'all'
						},
						'filter': {
							'stringValue': 'repos'
						}
					}
				},
				nextTask: t2.id,
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		console.log([ JSON.stringify(t1), JSON.stringify(t2), JSON.stringify(t3) ]);
	}

	// Seed workflow 2
	{
		const t3 = await prisma.task.create({
			data: {
				name: 'Reaction - Create a new Google event',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_EVENT,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'title': {
							'stringValue': 'This is a new event'
						},
						'start': {
							'stringValue': '2022-02-26T20:00:00+01:00'
						},
						'duration': {
							'stringValue': '2h0m0s'
						},
					}
				},
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t2 = await prisma.task.create({
			data: {
				name: 'Reaction - Create new Google sheet',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_SHEET,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'title': {
							'stringValue': 'This is a new sheet'
						},
					}
				},
				nextTask: t3.id,
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t1 = await prisma.task.create({
			data: {
				name: 'Action - When a new GitHub PR is open',
				type: TaskType.ACTION,
				action: TaskAction.GITHUB_NEW_PR_DETECTED,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'repo': {
							'stringValue': 'ifttt-like-test'
						},
						'user': {
							'stringValue': 'Cleopha'
						},
						'state': {
							'stringValue': 'all'
						},
						'filter': {
							'stringValue': 'repos'
						}
					}
				},
				nextTask: t2.id,
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		console.log([ JSON.stringify(t1), JSON.stringify(t2), JSON.stringify(t3) ]);
	}
}

async function seed(): Promise<void> {
	console.log('Start seeding database');

	const workflows = await createWorkflows();
	console.log(`Created workflows : ${ JSON.stringify(workflows) }`);

	await createTasks(workflows);

	console.log('Seed successfully finished');
}

seed();