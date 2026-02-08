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

        expect(host).toBe('pg.kajiyama.com.br');
        expect(port).toBe(5432);
        expect(user).toBe('system');
        expect(password).toBe('SystemPass_9b28s1@');
        expect(db).toBe('my_agents_db');
    });

    afterAll(async () => {
        await app.close();
    });
});
