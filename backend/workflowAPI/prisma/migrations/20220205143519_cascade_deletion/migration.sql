-- DropForeignKey
ALTER TABLE "Task" DROP CONSTRAINT "Task_workflowId_fkey";

-- AddForeignKey
ALTER TABLE "Task" ADD CONSTRAINT "Task_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;
