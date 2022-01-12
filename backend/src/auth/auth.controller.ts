import { Controller, Post, Body, UnauthorizedException } from '@nestjs/common';

import { compare, hash } from 'bcrypt';

import { RegisterDto, LoginDto } from './dto';
import { User } from '../user/entities';
import { UserService } from '../user';

@Controller('auth')
export class AuthController {
	constructor(private readonly userService: UserService) {}

	@Post('/register')
	async register(@Body() registerDto: RegisterDto): Promise<User> {
		const { password } = registerDto;

		// TODO: Handle error
		const hashedPassword = await hash(password, 10);
		return this.userService.create({ ...registerDto, password: hashedPassword });
	}

	@Post('/login')
	async login(@Body() loginDto: LoginDto): Promise<string> {
		const { email, password } = loginDto;

		const user = await this.userService.getByEmail(email);
		if (!(await compare(password, user.password))) {
			throw new UnauthorizedException('invalid password');
		}

		// TODO: handle session
		return 'User successfully logged in';
	}

	@Post('/logout')
	async logout(): Promise<string> {
		// TODO: check if user is login
		// TODO: Destroy user session
		return 'foo';
	}
}
