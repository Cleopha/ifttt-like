import { HttpException, HttpStatus } from '@nestjs/common';

/**
 * PrismaException is a wrapper around prisma error
 */
export class PrismaException extends HttpException {
	constructor(code: string, msg: string) {
		super(msg, HttpStatus.INTERNAL_SERVER_ERROR);
	}
}