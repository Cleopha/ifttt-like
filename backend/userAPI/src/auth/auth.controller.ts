import {
	Controller,
	Post,
	Body,
	UnauthorizedException,
	Session,
	HttpCode,
	Inject, forwardRef, HttpStatus, InternalServerErrorException,
} from '@nestjs/common';

import { compare, hash } from 'bcrypt';

import { ISession } from "@session";
import { UserService } from '@user';
import { User } from '@user/entities';

import { RegisterDto, LoginDto } from './dto';
import { AuthMiddleware } from './auth.guard';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('user')
@Controller('auth')
export class AuthController {
	constructor(
		@Inject(forwardRef(() => UserService)) private readonly userService: UserService
	) {}

	@Post('/register')
	@HttpCode(HttpStatus.CREATED)
	async register(@Body() registerDto: RegisterDto): Promise<User> {
		const { password } = registerDto;

		try {
			const hashedPassword = await hash(password, 10);
			return this.userService.create({ ...registerDto, password: hashedPassword });
		} catch (e) {
			throw new InternalServerErrorException(e.msg)
		}
	}

	@Post('/login')
	@HttpCode(HttpStatus.OK)
	async login(@Body() loginDto: LoginDto, @Session() session: ISession): Promise<string> {
		const { email, password } = loginDto;

		const user = await this.userService.getByEmail(email);
		if (!(await compare(password, user.password))) {
			throw new UnauthorizedException('invalid password');
		}

		session.user = { id: user.id };
		session.save();

		return 'User successfully logged in';
	}

	@Post('/logout')
	@AuthMiddleware()
	@HttpCode(HttpStatus.OK)
	async logout(@Session() session): Promise<string> {
		session.destroy();
		return 'User successfully logged out';
	}
}
