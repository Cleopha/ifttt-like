import { Controller, Get, Req } from '@nestjs/common';
import { Request } from 'express';

import { IAbout } from './about.types';
import { AboutService } from './about.service';

@Controller('about.json')
export class AboutController {
	constructor(private readonly aboutService: AboutService) {}

	// Build about object
	@Get()
	about(@Req() req: Request): IAbout {
		return {
			client: { host: req.ip },
			server: {
				current_time: Date.now(),
				services: [
					this.aboutService.ethService(),
					this.aboutService.nistService(),
					this.aboutService.githubService(),
					this.aboutService.googleService(),
					this.aboutService.coinMarketCapService(),
					this.aboutService.scalewayService(),
					this.aboutService.notionService(),
				]
			}
		};
	}
}
