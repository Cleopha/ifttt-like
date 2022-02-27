import { Injectable } from '@nestjs/common';
import * as Prisma from '@prisma/client';

import { Credential, Service } from '@protos';

@Injectable()
export class CredentialConvertor {
	grpcServiceToPrismaService(service: Service): Prisma.Service {
		const key = Object.keys(Service)[Object.values(Service).indexOf(service)];
		return (Prisma.Service as never)[key];
	}

	prismaServiceToGrpcService(service: Prisma.Service): Service {
		const key = Object.keys(Prisma.Service)[Object.values(Prisma.Service).indexOf(service)];
		return (Service as never)[key];
	}

	prismaCredentialToGrpcCredential(credential: Prisma.Credential): Credential {
		return { ...credential, service: this.prismaServiceToGrpcService(credential.service) };
	}
}