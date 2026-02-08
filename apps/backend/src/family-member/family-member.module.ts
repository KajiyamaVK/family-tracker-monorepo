import { Module } from '@nestjs/common';
import { FamilyMemberController } from './family-member.controller';
import { OtpModule } from '../otp/otp.module';
import { MailModule } from '../mail/mail.module';

@Module({
    imports: [OtpModule, MailModule],
    controllers: [FamilyMemberController],
})
export class FamilyMemberModule { }
