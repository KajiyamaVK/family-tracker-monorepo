import { Controller, Post, Body, InternalServerErrorException, Logger, UseGuards } from '@nestjs/common';
import { OtpService } from '../otp/otp.service';
import { MailService } from '../mail/mail.service';
import { RequestOtpDto } from './dto/request-otp.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('family-members')
export class FamilyMemberController {
    private readonly logger = new Logger(FamilyMemberController.name);

    constructor(
        private readonly otpService: OtpService,
        private readonly mailService: MailService,
    ) { }

    @Post('request-otp')
    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN)
    async requestOtp(@Body() requestOtpDto: RequestOtpDto) {
        const { name, email, role } = requestOtpDto;
        const otp = this.otpService.generateOtp();
        const savedOtp = await this.otpService.saveOtp(name, email, otp, role);

        try {
            await this.mailService.sendOtpEmail(email, otp);
        } catch (error) {
            this.logger.error(`Failed to send email to ${email}`, error.stack);
            await this.otpService.deleteOtp(savedOtp.id);
            throw new InternalServerErrorException('Failed to send email. Please try again.');
        }

        return { message: 'OTP sent successfully' };
    }
}
