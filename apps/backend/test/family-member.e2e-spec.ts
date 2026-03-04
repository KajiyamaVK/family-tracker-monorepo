import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';
import { Role } from '@prisma/client';
import { JwtService } from '@nestjs/jwt';
import { MailService } from '../src/mail/mail.service';

describe('FamilyMemberController (e2e)', () => {
    let app: INestApplication;
    let prisma: PrismaService;
    let jwtService: JwtService;

    const mockMailService = {
        sendOtpEmail: jest.fn().mockResolvedValue(undefined),
    };

    beforeAll(async () => {
        const moduleFixture: TestingModule = await Test.createTestingModule({
            imports: [AppModule],
        })
            .overrideProvider(MailService)
            .useValue(mockMailService)
            .compile();

        app = moduleFixture.createNestApplication();
        app.useGlobalPipes(new ValidationPipe());
        prisma = app.get(PrismaService);
        jwtService = app.get(JwtService);
        await app.init();
    });

    afterAll(async () => {
        // Clean up created users
        await prisma.familyMember.deleteMany({
            where: {
                email: {
                    in: ['admin@e2e.com', 'member@e2e.com']
                }
            }
        });
        await app.close();
    });

    describe('/family-members/request-otp (POST)', () => {
        let adminToken: string;
        let memberToken: string;

        beforeAll(async () => {
            // Create Admin
            const admin = await prisma.familyMember.create({
                data: {
                    first_name: 'Admin',
                    last_name: 'User',
                    email: 'admin@e2e.com',
                    role: Role.ADMIN
                }
            });
            // Create Member
            const member = await prisma.familyMember.create({
                data: {
                    first_name: 'Member',
                    last_name: 'User',
                    email: 'member@e2e.com',
                    role: Role.MEMBER
                }
            });

            // Sign tokens
            adminToken = jwtService.sign({ sub: admin.id, email: admin.email, role: Role.ADMIN });
            memberToken = jwtService.sign({ sub: member.id, email: member.email, role: Role.MEMBER });
        });

        it('should return 401 if no token provided', () => {
            return request(app.getHttpServer())
                .post('/family-members/request-otp')
                .send({ name: 'Test', email: 'test@example.com' })
                .expect(401);
        });

        it('should return 403 if user is MEMBER', () => {
            return request(app.getHttpServer())
                .post('/family-members/request-otp')
                .set('Authorization', `Bearer ${memberToken}`)
                .send({ name: 'Invited', email: 'invited@example.com' })
                .expect(403);
        });

        it('should return 201 if user is ADMIN', () => {
            return request(app.getHttpServer())
                .post('/family-members/request-otp')
                .set('Authorization', `Bearer ${adminToken}`)
                .send({ firstName: 'Invited', lastName: 'User', email: 'invited@example.com', role: Role.MEMBER })
                .expect(201);
        });
    });
});
