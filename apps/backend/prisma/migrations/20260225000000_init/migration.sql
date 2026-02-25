-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MEMBER');

-- CreateTable
CREATE TABLE "otp_codes" (
    "id" TEXT NOT NULL,
    "otp_code" TEXT NOT NULL,
    "member_name" TEXT NOT NULL,
    "member_email" TEXT NOT NULL,
    "is_used" BOOLEAN NOT NULL DEFAULT false,
    "is_expired" BOOLEAN NOT NULL DEFAULT false,
    "added_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "archived_at" TIMESTAMP(3),
    "role" "Role" NOT NULL DEFAULT 'MEMBER',

    CONSTRAINT "otp_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_members" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "google_id" TEXT,
    "refresh_token" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'MEMBER',

    CONSTRAINT "family_members_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "family_members_email_key" ON "family_members"("email");

-- CreateIndex
CREATE UNIQUE INDEX "family_members_google_id_key" ON "family_members"("google_id");

