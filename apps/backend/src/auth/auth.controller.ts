import { Controller, Post, Body, HttpCode, HttpStatus, UsePipes, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { GoogleLoginDto } from './dto/google-login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { Tokens } from './interfaces/tokens.interface';
import { JoiValidationPipe } from '../common/pipes/joi-validation.pipe';
import * as Joi from 'joi';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { GetCurrentUserId } from './decorators/get-current-user-id.decorator';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('login-google')
    @HttpCode(HttpStatus.OK)
    @UsePipes(new JoiValidationPipe(Joi.object({
        idToken: Joi.string().required()
    })))
    async loginWithGoogle(@Body() googleLoginDto: GoogleLoginDto): Promise<Tokens> {
        return this.authService.loginWithGoogle(googleLoginDto);
    }

    @Post('refresh')
    @HttpCode(HttpStatus.OK)
    @UsePipes(new JoiValidationPipe(Joi.object({
        refreshToken: Joi.string().required()
    })))
    async refreshTokens(@Body() refreshTokenDto: RefreshTokenDto): Promise<Tokens> {
        return this.authService.refreshTokens(refreshTokenDto);
    }

    @Post('logout')
    @UseGuards(JwtAuthGuard)
    @HttpCode(HttpStatus.OK)
    async logout(@GetCurrentUserId() userId: string): Promise<void> {
        return this.authService.logout(userId);
    }
}
