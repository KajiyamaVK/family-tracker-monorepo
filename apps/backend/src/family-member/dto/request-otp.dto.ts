import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class RequestOtpDto {
    @IsString()
    @IsNotEmpty()
    name: string;

    @IsEmail()
    email: string;
}
