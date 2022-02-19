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
				name: 'Google calendar Reaction 2',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_DOCUMENT,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'foo': {
							'stringValue': 'test'
						},
						'bar': {
							'numberValue': 4
						},
						'baz': {
							'boolValue': true
						}
					}
				},
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t2 = await prisma.task.create({
			data: {
				name: 'Google calendar Reaction',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_EVENT,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'foo': {
							'stringValue': 'test'
						},
						'bar': {
							'numberValue': 4
						},
						'baz': {
							'boolValue': true
						}
					}
				},
				nextTask: t3.id,
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t1 = await prisma.task.create({
			data: {
				name: 'Google calendar Action',
				type: TaskType.ACTION,
				action: TaskAction.GITHUB_ISSUE_OPEN,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'foo': {
							'stringValue': 'test'
						},
						'bar': {
							'numberValue': 4
						},
						'baz': {
							'boolValue': true
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
				name: 'Google calendar Reaction 2',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_EVENT,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'foo': {
							'stringValue': 'test'
						},
						'bar': {
							'numberValue': 4
						},
						'baz': {
							'boolValue': true
						}
					}
				},
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t2 = await prisma.task.create({
			data: {
				name: 'Google sheet Reaction',
				type: TaskType.REACTION,
				action: TaskAction.GOOGLE_CREATE_NEW_SHEET,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'foo': {
							'stringValue': 'test'
						},
						'bar': {
							'numberValue': 4
						},
						'baz': {
							'boolValue': true
						}
					}
				},
				nextTask: t3.id,
				workflow: { connect: { id: workflows[0].id } }
			}
		});

		const t1 = await prisma.task.create({
			data: {
				name: 'Github pr opened',
				type: TaskType.ACTION,
				action: TaskAction.GITHUB_PR_OPEN,
				params: {
					// https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Struct
					fields: {
						'foo': {
							'stringValue': 'test'
						},
						'bar': {
							'numberValue': 4
						},
						'baz': {
							'boolValue': true
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