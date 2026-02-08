import { Test, TestingModule } from '@nestjs/testing';
import { MailService } from './mail.service';
import * as nodemailer from 'nodemailer';

jest.mock('nodemailer');
const sendMailMock = jest.fn();
(nodemailer.createTransport as jest.Mock).mockReturnValue({
    sendMail: sendMailMock,
});

describe('MailService', () => {
    let service: MailService;

    beforeEach(async () => {
        jest.clearAllMocks();
        const module: TestingModule = await Test.createTestingModule({
            providers: [MailService],
        }).compile();

        service = module.get<MailService>(MailService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    describe('sendOtpEmail', () => {
        it('should send email with correct options', async () => {
            const email = 'test@example.com';
            const otp = '123456';

            await service.sendOtpEmail(email, otp);

            expect(nodemailer.createTransport).toHaveBeenCalled();
            expect(sendMailMock).toHaveBeenCalledWith(
                expect.objectContaining({
                    to: email,
                    subject: 'Your Family Tracker OTP Code',
                    html: expect.stringContaining(otp),
                }),
            );
        });
    });
});
