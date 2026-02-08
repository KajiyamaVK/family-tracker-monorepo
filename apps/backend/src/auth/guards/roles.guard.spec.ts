import { RolesGuard } from './roles.guard';
import { Reflector } from '@nestjs/core';
import { ExecutionContext } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { Role } from '@prisma/client';

describe('RolesGuard', () => {
    let guard: RolesGuard;
    let reflector: Reflector;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                RolesGuard,
                {
                    provide: Reflector,
                    useValue: {
                        getAllAndOverride: jest.fn(),
                    },
                },
            ],
        }).compile();

        guard = module.get<RolesGuard>(RolesGuard);
        reflector = module.get<Reflector>(Reflector);
    });

    const createMockContext = (userRole: Role | undefined): ExecutionContext => {
        return {
            getHandler: jest.fn(),
            getClass: jest.fn(),
            switchToHttp: jest.fn().mockReturnValue({
                getRequest: jest.fn().mockReturnValue({
                    user: { role: userRole },
                }),
            }),
        } as any;
    };

    it('should allow access if no roles are required', () => {
        jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue(undefined);
        const context = createMockContext(undefined);
        expect(guard.canActivate(context)).toBe(true);
    });

    it('should allow access if user has required role', () => {
        jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue([Role.ADMIN]);
        const context = createMockContext(Role.ADMIN);
        expect(guard.canActivate(context)).toBe(true);
    });

    it('should deny access if user does not have required role', () => {
        jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue([Role.ADMIN]);
        const context = createMockContext(Role.MEMBER);
        expect(guard.canActivate(context)).toBe(false);
    });

    it('should deny access if user has no role but role is required', () => {
        jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue([Role.ADMIN]);
        const context = createMockContext(undefined);
        expect(guard.canActivate(context)).toBe(false);
    });
});
