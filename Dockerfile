FROM node:lts-alpine

WORKDIR /usr/src/app

COPY apps/backend/package*.json ./
COPY apps/backend/prisma ./prisma
RUN npm install

COPY apps/backend/ .

RUN npm run build

COPY apps/backend/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["node", "dist/main"]
