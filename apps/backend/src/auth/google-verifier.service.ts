import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { OAuth2Client, TokenPayload } from 'google-auth-library';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class GoogleVerifierService {
    private client: OAuth2Client;

    private readonly logger = new Logger(GoogleVerifierService.name);

    constructor(private configService: ConfigService) {
        const clientId = this.configService.get<string>('GOOGLE_CLIENT_ID');
        this.client = new OAuth2Client(clientId);
    }

    async verify(token: string): Promise<TokenPayload> {
        const isDev = this.configService.get<string>('NODE_ENV') === 'development';

        if (isDev && token === 'DEV_TOKEN_123') {
            return {
                email: 'dev@example.com',
                sub: 'dev-google-id-123',
                email_verified: true,
                name: 'Dev User',
                iss: 'google',
                aud: this.configService.get<string>('GOOGLE_CLIENT_ID') || 'dev-client-id',
                exp: Math.floor(Date.now() / 1000) + 3600,
                iat: Math.floor(Date.now() / 1000),
            };
        }

        try {
            const ticket = await this.client.verifyIdToken({
                idToken: token,
                audience: this.configService.get<string>('GOOGLE_CLIENT_ID'),
            });
            const payload = ticket.getPayload();
            if (!payload) {
                throw new UnauthorizedException('Invalid Google Token');
            }
            return payload;
        } catch (error) {
            throw new UnauthorizedException('Invalid Google Token');
        }
    }
}
