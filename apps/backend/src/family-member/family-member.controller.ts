import { Controller, Post, Body, InternalServerErrorException } from '@nestjs/common';
import { OtpService } from '../otp/otp.service';
import { MailService } from '../mail/mail.service';
import { RequestOtpDto } from './dto/request-otp.dto';

@Controller('family-members')
export class FamilyMemberController {
    constructor(
        private readonly otpService: OtpService,
        private readonly mailService: MailService,
    ) { }

    @Post('request-otp')
    async requestOtp(@Body() requestOtpDto: RequestOtpDto) {
        const { name, email } = requestOtpDto;
        const otp = this.otpService.generateOtp();
        const savedOtp = await this.otpService.saveOtp(name, email, otp);

        try {
            await this.mailService.sendOtpEmail(email, otp);
        } catch (error) {
            await this.otpService.deleteOtp(savedOtp.id);
            throw new InternalServerErrorException('Failed to send email. Please try again.');
        }

        return { message: 'OTP sent successfully' };
    }
}
