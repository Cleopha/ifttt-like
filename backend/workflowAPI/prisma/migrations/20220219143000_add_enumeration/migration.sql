/*
  Warnings:

  - The values [GITHUB_PR_MERGE,GITHUB_ISSUE_CLOSE] on the enum `TaskAction` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "TaskAction_new" AS ENUM ('GITHUB_PR_OPEN', 'GITHUB_ISSUE_OPEN', 'TIMER_DATE', 'TIMER_INTERVAL', 'GOOGLE_CALENDAR_NEW_EVENT', 'GOOGLE_NEW_DOC', 'GOOGLE_NEW_SHEET');
ALTER TABLE "Task" ALTER COLUMN "action" TYPE "TaskAction_new" USING ("action"::text::"TaskAction_new");
ALTER TYPE "TaskAction" RENAME TO "TaskAction_old";
ALTER TYPE "TaskAction_new" RENAME TO "TaskAction";
DROP TYPE "TaskAction_old";
COMMIT;
