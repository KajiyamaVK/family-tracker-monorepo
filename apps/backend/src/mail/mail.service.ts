import { Injectable, Logger } from '@nestjs/common';
import * as nodemailer from 'nodemailer';

export interface IMailService {
    sendOtpEmail(email: string, otp: string): Promise<void>;
}

@Injectable()
export class MailService implements IMailService {
    private readonly logger = new Logger(MailService.name);
    private transporter: nodemailer.Transporter;

    constructor() {
        if (process.env.MAIL_HOST === 'smtp.gmail.com') {
            this.transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    user: process.env.MAIL_USER,
                    pass: process.env.MAIL_PASS,
                },
            });
        } else {
            this.transporter = nodemailer.createTransport({
                host: process.env.MAIL_HOST,
                port: Number(process.env.MAIL_PORT),
                auth: {
                    user: process.env.MAIL_USER,
                    pass: process.env.MAIL_PASS,
                },
                secure: false, // true for 465, false for other ports
            });
        }
    }

    async sendOtpEmail(email: string, otp: string): Promise<void> {
        this.logger.log(`Attempting to send OTP email to ${email}`);
        await this.transporter.sendMail({
            from: '"Family Tracker" <noreply@familytracker.com>', // TODO: Use env var or better sender
            to: email,
            subject: 'Your Family Tracker OTP Code',
            html: `<p>Your OTP code is: <b>${otp}</b></p>`,
        });
        this.logger.log(`OTP email sent successfully to ${email}`);
    }
}
