import { ApiProperty } from '@nestjs/swagger';
import { TaskRo } from '../../task/ro/task.ro';

export class WorkflowRO {
	@ApiProperty({ description: 'Workflow unique identifier' })
	id: string;

	@ApiProperty({ description: 'Workflow owner' })
	owner: string;

	@ApiProperty()
	name: string;

	@ApiProperty({ type: TaskRo, isArray: true })
	tasks: TaskRo[];
}