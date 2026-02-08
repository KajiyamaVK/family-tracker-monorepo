import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module'; // Import AppModule
import { MailService } from '../src/mail/mail.service';
import { PrismaService } from '../src/prisma/prisma.service';

describe('FamilyMemberController (e2e)', () => {
    let app: INestApplication;
    let prismaService: PrismaService;
    const mockMailService = {
        sendOtpEmail: jest.fn().mockResolvedValue(true),
    };

    beforeAll(async () => {
        const moduleFixture: TestingModule = await Test.createTestingModule({
            imports: [AppModule],
        })
            .overrideProvider(MailService)
            .useValue(mockMailService)
            .compile();

        app = moduleFixture.createNestApplication();
        prismaService = app.get<PrismaService>(PrismaService);
        await app.init();
    });

    afterAll(async () => {
        // Clean up test data
        await prismaService.otpCode.deleteMany({
            where: { member_email: 'e2e@example.com' },
        });
        await app.close();
    });

    it('/family-members/request-otp (POST)', async () => {
        return request(app.getHttpServer())
            .post('/family-members/request-otp')
            .send({ name: 'E2E Test User', email: 'e2e@example.com' })
            .expect(201)
            .expect((res) => {
                expect(res.body.message).toEqual('OTP sent successfully');
                expect(mockMailService.sendOtpEmail).toHaveBeenCalled();
            });
    });
});
