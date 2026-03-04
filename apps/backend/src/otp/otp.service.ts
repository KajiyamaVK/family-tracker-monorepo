import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { OtpCode, Role } from '@prisma/client';
import * as crypto from 'crypto';

export interface IOtpService {
    generateOtp(): string;
    saveOtp(firstName: string, lastName: string, email: string, otp: string, role?: Role): Promise<OtpCode>;
    markAsUsed(id: string): Promise<OtpCode>;
    deleteOtp(id: string): Promise<void>;
}

@Injectable()
export class OtpService implements IOtpService {
    constructor(private prisma: PrismaService) { }

    generateOtp(): string {
        return crypto.randomInt(100000, 999999).toString();
    }

    async saveOtp(firstName: string, lastName: string, email: string, otp: string, role: Role = Role.MEMBER): Promise<OtpCode> {
        return this.prisma.otpCode.create({
            data: {
                member_first_name: firstName,
                member_last_name: lastName,
                member_email: email,
                otp_code: otp,
                role: role,
            },
        });
    }

    async markAsUsed(id: string): Promise<OtpCode> {
        return this.prisma.otpCode.update({
            where: { id },
            data: { is_used: true },
        });
    }

    async deleteOtp(id: string): Promise<void> {
        await this.prisma.otpCode.delete({
            where: { id },
        });
    }
}
