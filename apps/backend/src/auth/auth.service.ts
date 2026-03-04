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
            const rawName = payload.name || 'New User';
            const parts = rawName.split(' ');
            const firstName = parts[0];
            const lastName = parts.length > 1 ? parts.slice(1).join(' ') : 'User';

            user = await this.prisma.familyMember.create({
                data: {
                    email,
                    first_name: firstName,
                    last_name: lastName,
                    googleId: payload.sub,
                },
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
