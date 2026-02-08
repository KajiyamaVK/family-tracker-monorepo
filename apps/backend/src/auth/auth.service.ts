import { Injectable, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { GoogleVerifierService } from './google-verifier.service';
import { GoogleLoginDto } from './dto/google-login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { Tokens } from './interfaces/tokens.interface';
import { JwtPayload } from './interfaces/jwt-payload.interface';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AuthService {
    constructor(
        private prisma: PrismaService,
        private jwtService: JwtService,
        private googleVerifier: GoogleVerifierService,
        private configService: ConfigService,
    ) { }

    async loginWithGoogle(googleLoginDto: GoogleLoginDto): Promise<Tokens> {
        const payload = await this.googleVerifier.verify(googleLoginDto.idToken);
        const email = payload.email;

        if (!email) {
            throw new UnauthorizedException('Email not found in Google Token');
        }

        let user = await this.prisma.familyMember.findUnique({
            where: { email },
        });

        if (!user) {
            const isDev = this.configService.get<string>('NODE_ENV') === 'development';
            // In Development mode, we allow auto-creation of the 'Dev User' 
            // to facilitate testing with the Dev Bypass token (without needing a real Google account).
            if (isDev && email === 'dev@example.com') {
                user = await this.prisma.familyMember.create({
                    data: {
                        email,
                        name: payload.name || 'Dev User',
                        googleId: payload.sub,
                    },
                });
            } else {
                throw new UnauthorizedException('User not found');
            }
        }

        // Link Google ID if not already linked
        if (!user.googleId && payload.sub) {
            await this.prisma.familyMember.update({
                where: { id: user.id },
                data: { googleId: payload.sub },
            });
        }

        const tokens = await this.getTokens(user.id, user.email, user.role);
        await this.updateRefreshTokenHash(user.id, tokens.refreshToken);

        return tokens;
    }

    async refreshTokens(refreshTokenDto: RefreshTokenDto): Promise<Tokens> {
        const { refreshToken } = refreshTokenDto;

        let payload: JwtPayload;
        try {
            payload = await this.jwtService.verifyAsync(refreshToken, {
                secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
            });
        } catch (e) {
            throw new UnauthorizedException('Invalid Refresh Token');
        }

        const user = await this.prisma.familyMember.findUnique({
            where: { id: payload.sub },
        });

        if (!user || !user.refreshToken) {
            throw new ForbiddenException('Access Denied');
        }

        const refreshTokenMatches = await bcrypt.compare(
            refreshToken,
            user.refreshToken,
        );

        if (!refreshTokenMatches) {
            throw new ForbiddenException('Access Denied');
        }

        const tokens = await this.getTokens(user.id, user.email, user.role);
        await this.updateRefreshTokenHash(user.id, tokens.refreshToken);

        return tokens;
    }

    async updateRefreshTokenHash(userId: string, refreshToken: string): Promise<void> {
        const hash = await bcrypt.hash(refreshToken, 10);
        await this.prisma.familyMember.update({
            where: { id: userId },
            data: {
                refreshToken: hash,
            },
        });
    }

    async logout(userId: string): Promise<void> {
        await this.prisma.familyMember.update({
            where: { id: userId },
            data: {
                refreshToken: null,
            },
        });
    }

    async getTokens(userId: string, email: string, role: string): Promise<Tokens> {
        const jwtPayload: JwtPayload = {
            sub: userId,
            email: email,
            role: role,
        };

        const [at, rt] = await Promise.all([
            this.jwtService.signAsync(jwtPayload, {
                secret: this.configService.get<string>('JWT_SECRET'),
                expiresIn: '15m',
            }),
            this.jwtService.signAsync(jwtPayload, {
                secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
                expiresIn: '7d',
            }),
        ]);

        return {
            accessToken: at,
            refreshToken: rt,
        };
    }
}
