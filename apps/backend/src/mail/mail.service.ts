import { Injectable } from '@nestjs/common';
import * as nodemailer from 'nodemailer';

export interface IMailService {
    sendOtpEmail(email: string, otp: string): Promise<void>;
}

@Injectable()
export class MailService implements IMailService {
    private transporter: nodemailer.Transporter;

    constructor() {
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

    async sendOtpEmail(email: string, otp: string): Promise<void> {
        await this.transporter.sendMail({
            from: '"Family Tracker" <noreply@familytracker.com>', // TODO: Use env var or better sender
            to: email,
            subject: 'Your Family Tracker OTP Code',
            html: `<p>Your OTP code is: <b>${otp}</b></p>`,
        });
    }
}
