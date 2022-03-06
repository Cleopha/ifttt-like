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

import { ISession } from '@session';
import { UserService } from '@user';
import { User } from '@user/entities';

import { RegisterDto, LoginDto } from './dto';
import { AuthMiddleware } from './auth.guard';
import {
	ApiCreatedResponse,
	ApiInternalServerErrorResponse,
	ApiOkResponse, ApiOperation,
	ApiTags,
	ApiUnauthorizedResponse
} from '@nestjs/swagger';
import { UserRO } from './ro/register.ro';

@ApiTags('user')
@Controller('auth')
export class AuthController {
	constructor(
		@Inject(forwardRef(() => UserService)) private readonly userService: UserService
	) {
	}

	@Post('/register')
	@HttpCode(HttpStatus.CREATED)
	@ApiOperation({ summary: 'Register a new user in the application' })
	@ApiCreatedResponse({ type: UserRO })
	@ApiInternalServerErrorResponse({ description: 'something went wrong' })
	async register(@Body() registerDto: RegisterDto): Promise<User> {
		const { password } = registerDto;

		try {
			const hashedPassword = await hash(password, 10);
			return this.userService.create({ ...registerDto, password: hashedPassword });
		} catch (e) {
			throw new InternalServerErrorException(e.msg);
		}
	}

	@Post('/login')
	@HttpCode(HttpStatus.OK)
	@ApiOperation({ summary: 'Login user using basic auth and create a session' })
	@ApiOkResponse({ description: 'User successfully logged in' })
	@ApiUnauthorizedResponse({ description: 'invalid password' })
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
	@ApiOperation({ summary: 'Logout user and destroy his session' })
	@ApiOkResponse({ description: 'User successfully logged out', type: 'string' })
	@ApiUnauthorizedResponse({ description: 'user not logged in' })
	async logout(@Session() session): Promise<string> {
		session.destroy();
		return 'User successfully logged out';
	}
}
