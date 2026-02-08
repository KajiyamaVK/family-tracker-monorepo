import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { JwtPayload } from '../interfaces/jwt-payload.interface';

export const GetCurrentUserId = createParamDecorator(
    (data: undefined, context: ExecutionContext): string => {
        const request = context.switchToHttp().getRequest();
        const user = request.user as any;
        return user.id;
    },

);
