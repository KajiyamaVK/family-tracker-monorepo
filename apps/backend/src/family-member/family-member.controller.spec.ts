import { Test, TestingModule } from '@nestjs/testing';
import { FamilyMemberController } from './family-member.controller';
import { OtpService } from '../otp/otp.service';
import { MailService } from '../mail/mail.service';
import { RequestOtpDto } from './dto/request-otp.dto';
import { BadRequestException, InternalServerErrorException } from '@nestjs/common';
import { Role } from '@prisma/client';

const mockOtpService = {
    generateOtp: jest.fn(),
    saveOtp: jest.fn(),
    deleteOtp: jest.fn(),
};

const mockMailService = {
    sendOtpEmail: jest.fn(),
};

describe('FamilyMemberController', () => {
    let controller: FamilyMemberController;

    beforeEach(async () => {
        jest.clearAllMocks();
        const module: TestingModule = await Test.createTestingModule({
            controllers: [FamilyMemberController],
            providers: [
                { provide: OtpService, useValue: mockOtpService },
                { provide: MailService, useValue: mockMailService },
            ],
        }).compile();

        controller = module.get<FamilyMemberController>(FamilyMemberController);
    });

    it('should be defined', () => {
        expect(controller).toBeDefined();
    });

    describe('requestOtp', () => {
        it('should generate otp, save it, and send email', async () => {
            const dto: RequestOtpDto = { firstName: 'Test', lastName: 'User', email: 'test@example.com', role: Role.ADMIN };
            const otp = '123456';
            mockOtpService.generateOtp.mockReturnValue(otp);
            mockOtpService.saveOtp.mockResolvedValue({ id: 'uuid', ...dto, otp_code: otp });
            mockMailService.sendOtpEmail.mockResolvedValue(undefined);

            await controller.requestOtp(dto);

            expect(mockOtpService.generateOtp).toHaveBeenCalled();
            expect(mockOtpService.saveOtp).toHaveBeenCalledWith(dto.firstName, dto.lastName, dto.email, otp, dto.role);
            expect(mockMailService.sendOtpEmail).toHaveBeenCalledWith(dto.email, otp);
            expect(mockOtpService.deleteOtp).not.toHaveBeenCalled();
        });

        it('should delete otp (rollback) if email sending fails', async () => {
            const dto: RequestOtpDto = { firstName: 'Test', lastName: 'User', email: 'test@example.com' };
            const otp = '123456';
            const otpId = 'uuid';
            mockOtpService.generateOtp.mockReturnValue(otp);
            mockOtpService.saveOtp.mockResolvedValue({ id: otpId, ...dto, otp_code: otp });
            mockMailService.sendOtpEmail.mockRejectedValue(new Error('Mail error'));

            await expect(controller.requestOtp(dto)).rejects.toThrow();

            expect(mockOtpService.saveOtp).toHaveBeenCalled();
            expect(mockMailService.sendOtpEmail).toHaveBeenCalled();
            expect(mockOtpService.deleteOtp).toHaveBeenCalledWith(otpId);
        });
    });
});
