-- CreateEnum
CREATE TYPE "TaskType" AS ENUM ('ACTION', 'REACTION');

-- CreateEnum
CREATE TYPE "TaskAction" AS ENUM ('GITHUB_PR_MERGE', 'GITHUB_ISSUE_CLOSE', 'TIMER_DATE', 'TIMER_INTERVAL');

-- CreateTable
CREATE TABLE "Workflow" (
    "id" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Workflow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Task" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "type" "TaskType" NOT NULL,
    "action" "TaskAction" NOT NULL,
    "param" JSONB NOT NULL,
    "workflowId" TEXT NOT NULL,

    CONSTRAINT "Task_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Task" ADD CONSTRAINT "Task_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
