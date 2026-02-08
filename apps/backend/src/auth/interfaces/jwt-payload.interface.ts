export type JwtPayload = {
    sub: string;
    email: string;
    familyId?: string; // Optional if not yet assigned to a family
    role?: string;
};
