import { HttpException, HttpStatus } from '@nestjs/common';

export class PrismaException extends HttpException {
	constructor(code: string, msg: string) {
		super(msg, HttpStatus.INTERNAL_SERVER_ERROR);
	}
}