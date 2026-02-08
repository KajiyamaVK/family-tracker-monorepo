import { Test, TestingModule } from '@nestjs/testing';
import { OtpService } from './otp.service';
import { PrismaService } from '../prisma/prisma.service';
import { Role } from '@prisma/client';

const mockPrismaService = {
    otpCode: {
        create: jest.fn(),
        update: jest.fn(),
        delete: jest.fn(),
    },
};

describe('OtpService', () => {
    let service: OtpService;
    let prisma: PrismaService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                OtpService,
                { provide: PrismaService, useValue: mockPrismaService },
            ],
        }).compile();

        service = module.get<OtpService>(OtpService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    describe('generateOtp', () => {
        it('should generate a 6-digit numeric string', () => {
            const otp = service.generateOtp();
            expect(otp).toHaveLength(6);
            expect(otp).toMatch(/^\d+$/);
        });
    });

    describe('saveOtp', () => {
        it('should save otp to database', async () => {
            const otp = '123456';
            const name = 'Test User';
            const email = 'test@example.com';
            const role = Role.ADMIN;
            const expectedResult = { id: 'uuid', otp_code: otp, member_name: name, member_email: email, role, is_used: false, is_expired: false, added_at: new Date(), archived_at: null };

            mockPrismaService.otpCode.create.mockResolvedValue(expectedResult);

            const result = await service.saveOtp(name, email, otp, role);
            expect(result).toEqual(expectedResult);
            expect(prisma.otpCode.create).toHaveBeenCalledWith({
                data: {
                    otp_code: otp,
                    member_name: name,
                    member_email: email,
                    role: role,
                },
            });
        });

        it('should use default role MEMBER if not provided', async () => {
            const otp = '123456';
            const name = 'Test User';
            const email = 'test@example.com';
            // Mock implementation doesn't strictly need to return correct object if we only check call args, 
            // but consistency is good.
            const expectedResult = { id: 'uuid', otp_code: otp, member_name: name, member_email: email, role: Role.MEMBER, is_used: false, is_expired: false, added_at: new Date(), archived_at: null };

            mockPrismaService.otpCode.create.mockResolvedValue(expectedResult);

            await service.saveOtp(name, email, otp);
            expect(prisma.otpCode.create).toHaveBeenCalledWith({
                data: {
                    otp_code: otp,
                    member_name: name,
                    member_email: email,
                    role: Role.MEMBER,
                },
            });
        });
    });

    describe('markAsUsed', () => {
        it('should mark otp as used', async () => {
            const id = 'uuid';
            const expectedResult = { id, is_used: true, is_expired: false };
            mockPrismaService.otpCode.update.mockResolvedValue(expectedResult);

            const result = await service.markAsUsed(id);
            expect(result).toEqual(expectedResult);
            expect(prisma.otpCode.update).toHaveBeenCalledWith({
                where: { id },
                data: { is_used: true },
            });
        });
    });

    describe('deleteOtp', () => {
        it('should delete otp from database', async () => {
            const id = 'uuid';
            mockPrismaService.otpCode.delete.mockResolvedValue({ id });

            await service.deleteOtp(id);
            expect(prisma.otpCode.delete).toHaveBeenCalledWith({ where: { id } });
        });
    });
});
