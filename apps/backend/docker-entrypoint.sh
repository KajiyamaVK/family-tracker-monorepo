#!/bin/sh

# Exit on error
set -e

echo "Constructing DATABASE_URL safely..."
export DATABASE_URL=$(node -e "if (process.env.POSTGRES_USER && process.env.POSTGRES_PASSWORD) { console.log(\`postgresql://\${process.env.POSTGRES_USER}:\${encodeURIComponent(process.env.POSTGRES_PASSWORD)}@\${process.env.POSTGRES_HOST}:\${process.env.POSTGRES_PORT}/\${process.env.POSTGRES_DB}\`) } else { console.log(process.env.DATABASE_URL) }")

echo "Running database migrations..."
npx prisma migrate deploy

echo "Starting the application..."
exec "$@"
