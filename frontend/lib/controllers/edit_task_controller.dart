import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

class EditTaskController extends GetxController {
  Task task;

  EditTaskController({
    required this.task,
  });

  Future<void> setIfThis(FlowAR newAction) async {
    task.workflowId ??=
        (await apiController.taskAPI.postWorkflow(apiController.user!.uid, ''))
            .id;
    task = await apiController.taskAPI.addAction(
      apiController.user!.uid,
      task.workflowId!,
      "",
      newAction,
    );
    update();
  }

  Future<void> addThenThat(FlowAR newRection) async {
    task.workflowId ??=
        (await apiController.taskAPI.postWorkflow(apiController.user!.uid, ''))
            .id;
    task = await apiController.taskAPI.addReaction(
      apiController.user!.uid,
      task.workflowId!,
      "",
      newRection,
    );
    update();
  }
}
