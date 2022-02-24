-- CreateEnum
CREATE TYPE "Service" AS ENUM ('GITHUB', 'GOOGLE', 'SCALEWAY', 'COINMARKET', 'DOCKER', 'ONEDRIVE', 'NOTION');

-- CreateTable
CREATE TABLE "Storage" (
    "owner" TEXT NOT NULL,

    CONSTRAINT "Storage_pkey" PRIMARY KEY ("owner")
);

-- CreateTable
CREATE TABLE "Credential" (
    "id" TEXT NOT NULL,
    "service" "Service" NOT NULL,
    "token" TEXT NOT NULL,
    "storageId" TEXT NOT NULL,

    CONSTRAINT "Credential_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Storage_owner_key" ON "Storage"("owner");

-- AddForeignKey
ALTER TABLE "Credential" ADD CONSTRAINT "Credential_storageId_fkey" FOREIGN KEY ("storageId") REFERENCES "Storage"("owner") ON DELETE CASCADE ON UPDATE CASCADE;
