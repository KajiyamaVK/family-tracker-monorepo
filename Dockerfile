FROM node:lts-alpine

WORKDIR /usr/src/app

COPY apps/backend/package*.json ./
COPY apps/backend/prisma ./prisma
RUN npm install

COPY apps/backend/ .

RUN npm run build

EXPOSE 3000

CMD ["node", "dist/main"]
