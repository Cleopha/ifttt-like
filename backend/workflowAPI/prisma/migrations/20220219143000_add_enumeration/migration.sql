/*
  Warnings:

  - The values [GITHUB_PR_MERGE,GITHUB_ISSUE_CLOSE] on the enum `TaskAction` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "TaskAction_new" AS ENUM (
        'GITHUB_NEW_PR_DETECTED',
        'GITHUB_NEW_ISSUE_DETECTED',
        'GITHUB_NEW_ISSUE_ASSIGNATION_DETECTED',
        'GITHUB_NEW_ISSUE_CLOSED_DETECTED',
        'GOOGLE_NEW_INCOMING_EVENT',
        'SCALEWAY_VOLUME_EXCEEDS_LIMIT',
        'COINMARKETCAP_ASSET_VARIATION_DETECTED',
        'NIST_NEW_CVE_DETECTED',
        'GOOGLE_CREATE_NEW_EVENT',
        'GOOGLE_CREATE_NEW_DOCUMENT',
        'GOOGLE_CREATE_NEW_SHEET',
        'SCALEWAY_CREATE_NEW_FLEXIBLE_IP',
        'SCALEWAY_CREATE_NEW_INSTANCE',
        'SCALEWAY_CREATE_NEW_DATABASE',
        'SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER',
        'SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY',
        'ETH_SEND_TRANSACTION',
        'NOTION_CREATE_NEW_PAGE'
    );
ALTER TABLE "Task" ALTER COLUMN "action" TYPE "TaskAction_new" USING ("action"::text::"TaskAction_new");
ALTER TYPE "TaskAction" RENAME TO "TaskAction_old";
ALTER TYPE "TaskAction_new" RENAME TO "TaskAction";
DROP TYPE "TaskAction_old";
COMMIT;
