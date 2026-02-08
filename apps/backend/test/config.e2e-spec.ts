import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './../src/app.module';

describe('Config (e2e)', () => {
    let app: INestApplication;
    let configService: ConfigService;

    beforeEach(async () => {
        const moduleFixture: TestingModule = await Test.createTestingModule({
            imports: [AppModule],
        }).compile();

        app = moduleFixture.createNestApplication();
        await app.init();

        configService = app.get<ConfigService>(ConfigService);
    });

    it('should load postgres configuration', () => {
        const host = configService.get<string>('POSTGRES_HOST');
        const port = configService.get<number>('POSTGRES_PORT');
        const user = configService.get<string>('POSTGRES_USER');
        const password = configService.get<string>('POSTGRES_PASSWORD');
        const db = configService.get<string>('POSTGRES_DB');

        expect(host).toBeDefined();
        expect(port).toBeDefined();
        expect(user).toBeDefined();
        expect(password).toBeDefined();
        expect(db).toBeDefined();
    });

    afterAll(async () => {
        await app.close();
    });
});
