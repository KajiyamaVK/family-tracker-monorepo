import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { GoogleVerifierService } from './google-verifier.service';
import { PrismaService } from '../prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { UnauthorizedException } from '@nestjs/common';
import { GoogleLoginDto } from './dto/google-login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { TokenPayload } from 'google-auth-library';
import * as bcrypt from 'bcrypt';

jest.mock('bcrypt'); // Mock bcrypt module

describe('AuthService', () => {
    let service: AuthService;
    let googleVerifier: GoogleVerifierService;
    let prisma: PrismaService;
    let jwtService: JwtService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AuthService,
                {
                    provide: GoogleVerifierService,
                    useValue: {
                        verify: jest.fn(),
                    },
                },
                {
                    provide: PrismaService,
                    useValue: {
                        familyMember: {
                            findUnique: jest.fn(),
                            update: jest.fn(),
                            create: jest.fn(),
                        },
                    },
                },
                {
                    provide: JwtService,
                    useValue: {
                        signAsync: jest.fn(),
                        verifyAsync: jest.fn(),
                    },
                },
                {
                    provide: ConfigService,
                    useValue: {
                        get: jest.fn().mockReturnValue('secret'),
                    },
                },
            ],
        }).compile();

        service = module.get<AuthService>(AuthService);
        googleVerifier = module.get<GoogleVerifierService>(GoogleVerifierService);
        prisma = module.get<PrismaService>(PrismaService);
        jwtService = module.get<JwtService>(JwtService);
    });

    describe('loginWithGoogle', () => {
        const loginDto: GoogleLoginDto = { idToken: 'valid-token' };
        const googleProfile: TokenPayload = {
            email: 'test@example.com',
            name: 'Test User',
            sub: '12345',
            iss: 'google',
            aud: 'client-id',
            iat: 123456,
            exp: 1234567
        };

        it('should return tokens if user exists', async () => {
            jest.spyOn(googleVerifier, 'verify').mockResolvedValue(googleProfile);
            jest.spyOn(prisma.familyMember, 'findUnique').mockResolvedValue({
                id: 'user-id',
                email: 'test@example.com',
                name: 'Test User',
                refreshToken: 'hashed-rt',
                createdAt: new Date(),
                updatedAt: new Date(),
                googleId: null,
            } as any);

            jest.spyOn(jwtService, 'signAsync').mockResolvedValue('jwt-token');
            jest.spyOn(prisma.familyMember, 'update').mockResolvedValue({} as any);
            (bcrypt.hash as jest.Mock).mockResolvedValue('new-hashed-rt');

            const result = await service.loginWithGoogle(loginDto);

            expect(result).toEqual({ accessToken: 'jwt-token', refreshToken: 'jwt-token' });
            expect(prisma.familyMember.update).toHaveBeenCalled();
        });

        it('should create a new user if user does not exist', async () => {
            jest.spyOn(googleVerifier, 'verify').mockResolvedValue(googleProfile);
            jest.spyOn(prisma.familyMember, 'findUnique').mockResolvedValue(null);

            jest.spyOn(prisma.familyMember, 'create').mockResolvedValue({
                id: 'new-user-id',
                email: 'test@example.com',
                name: 'Test User',
                googleId: '12345',
                role: 'MEMBER',
                createdAt: new Date(),
                updatedAt: new Date(),
                refreshToken: null,
            } as any);

            jest.spyOn(jwtService, 'signAsync').mockResolvedValue('jwt-token');
            jest.spyOn(prisma.familyMember, 'update').mockResolvedValue({} as any);
            (bcrypt.hash as jest.Mock).mockResolvedValue('new-hashed-rt');

            const result = await service.loginWithGoogle(loginDto);

            expect(result).toEqual({ accessToken: 'jwt-token', refreshToken: 'jwt-token' });
            expect(prisma.familyMember.create).toHaveBeenCalledWith({
                data: {
                    email: 'test@example.com',
                    first_name: 'Test',
                    last_name: 'User',
                    googleId: '12345',
                },
            });
        });
    });

    describe('refreshTokens', () => {
        const refreshDto: RefreshTokenDto = { refreshToken: 'valid-refresh-token' };
        const userId = 'user-id';
        const email = 'test@example.com';
        const decodedToken = { sub: userId, email };

        it('should rotate tokens if refresh token is valid', async () => {
            jest.spyOn(jwtService, 'verifyAsync').mockResolvedValue(decodedToken);
            jest.spyOn(prisma.familyMember, 'findUnique').mockResolvedValue({
                id: userId,
                email: email,
                refreshToken: 'hashed-valid-refresh-token',
            } as any);

            (bcrypt.compare as jest.Mock).mockResolvedValue(true);
            (bcrypt.hash as jest.Mock).mockResolvedValue('new-hashed-rt');

            jest.spyOn(jwtService, 'signAsync').mockResolvedValue('new-token');
            jest.spyOn(prisma.familyMember, 'update').mockResolvedValue({} as any);

            const result = await service.refreshTokens(refreshDto);

            expect(result).toEqual({ accessToken: 'new-token', refreshToken: 'new-token' });
            expect(prisma.familyMember.update).toHaveBeenCalled();
        });

        it('should throw UnauthorizedException on invalid token verify', async () => {
            jest.spyOn(jwtService, 'verifyAsync').mockRejectedValue(new Error('Invalid token'));
            await expect(service.refreshTokens(refreshDto)).rejects.toThrow(UnauthorizedException);
        });
    });
});
