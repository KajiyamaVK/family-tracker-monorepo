import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import request from 'supertest';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { AppModule } from '../src/app.module';
import { GoogleVerifierService } from '../src/auth/google-verifier.service';
import { PrismaService } from '../src/prisma/prisma.service';

describe('AuthController (e2e)', () => {
    let app: INestApplication;
    let prisma: PrismaService;
    let jwtService: JwtService;

    const mockGoogleVerifier = {
        verify: jest.fn(),
    };

    beforeAll(async () => {
        const moduleFixture: TestingModule = await Test.createTestingModule({
            imports: [AppModule],
        })
            .overrideProvider(GoogleVerifierService)
            .useValue(mockGoogleVerifier)
            .compile();

        app = moduleFixture.createNestApplication();
        prisma = app.get(PrismaService);
        jwtService = app.get(JwtService);
        await app.init();
    });

    afterAll(async () => {
        await app.close();
    });

    describe('/auth/login-google (POST)', () => {
        it('should return tokens on valid google login', async () => {
            mockGoogleVerifier.verify.mockResolvedValue({
                email: 'e2e-test@example.com',
                name: 'E2E Test User',
                googleId: 'google-123',
            });

            // We need to ensure the user exists in DB for login to succeed (logic decision: only existing users?)
            // Implementation Plan said: "Prerequisites: A FamilyMember must already exist".
            // So we must seed the user.

            await prisma.familyMember.create({
                data: {
                    email: 'e2e-test@example.com',
                    name: 'E2E Test User',

                    // But currently schema has password. We haven't migrated DB yet.
                    // Phase 2 includes "Update schema".
                    // So this E2E test might fail on DB constraints if we run it now without schema change.
                    // BUT: we are in Phase 1 (Contract). The tests define expectations.
                    // If the schema update is part of Phase 2, we should probably do the schema update NOW if it blocks the test from even passing later?
                    // Or we define the test expecting the new schema.
                    // For now, I will omit password field in create, assuming schema will be updated.
                    // If this throws now, it confirms Red state.
                } as any,
            }).catch(() => { }); // Ignore if exists

            return request(app.getHttpServer())
                .post('/auth/login-google')
                .send({ idToken: 'valid-token' })
                .expect(200)
                .expect((res) => {
                    expect(res.body).toHaveProperty('accessToken');
                    expect(res.body).toHaveProperty('refreshToken');
                });
        });

        it('should return 401 if google token invalid', async () => {
            mockGoogleVerifier.verify.mockRejectedValue(new UnauthorizedException('Invalid token'));

            return request(app.getHttpServer())
                .post('/auth/login-google')
                .send({ idToken: 'invalid-token' })
                .expect(401); // Or 500 depending on how we handle error, but 401 is expected contract
        });
    });

    describe('/auth/refresh (POST)', () => {
        it('should return new tokens', async () => {
            const email = 'refresh-test@example.com';
            await prisma.familyMember.deleteMany({ where: { email } });

            // Create user
            const user = await prisma.familyMember.create({
                data: {
                    email,
                    name: 'Refresh Test User',
                } as any,
            });

            const configService = app.get<ConfigService>(ConfigService);
            const refreshSecret = configService.get<string>('JWT_REFRESH_SECRET');

            const payload = { sub: user.id, email: user.email, role: 'MEMBER' };
            const refreshToken = await jwtService.signAsync(payload, {
                secret: refreshSecret,
                expiresIn: '7d',
            });

            const hash = await bcrypt.hash(refreshToken, 10);

            await prisma.familyMember.update({
                where: { id: user.id },
                data: { refreshToken: hash },
            });

            return request(app.getHttpServer())
                .post('/auth/refresh')
                .send({ refreshToken: refreshToken })
                .expect(200)
                .expect((res) => {
                    expect(res.body).toHaveProperty('accessToken');
                    expect(res.body).toHaveProperty('refreshToken');
                });
        });
    });

    describe('/auth/logout (POST)', () => {
        it('should log out user and invalidate refresh token', async () => {
            // 1. Setup: Create user and set refresh token 
            const email = 'logout-test@example.com';
            await prisma.familyMember.deleteMany({ where: { email } });

            const user = await prisma.familyMember.create({
                data: {
                    email,
                    name: 'Logout Test User',
                    refreshToken: await bcrypt.hash('valid-refresh', 10),
                } as any,
            });

            // 2. Login to get access token
            const accessToken = await jwtService.signAsync({
                sub: user.id,
                email: user.email,
                role: 'MEMBER'
            }, {
                secret: process.env.JWT_SECRET || 'defaultSecret'
            });


            // 3. Request Logout
            await request(app.getHttpServer())
                .post('/auth/logout')
                .set('Authorization', `Bearer ${accessToken}`)
                .expect(200);

            // 4. Verify DB
            const updatedUser = await prisma.familyMember.findUnique({ where: { id: user.id } });
            expect(updatedUser?.refreshToken).toBeNull();
        });
    });
});
