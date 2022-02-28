import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController with StateMixin<List<Task>> {
  static TaskController instance = Get.find();

  List<Task> _tasks = <Task>[];

  Future<void> getTasks() async {
    if (apiController.user == null) return;
    change(_tasks, status: RxStatus.loading());

    try {
      _tasks = await apiController.taskAPI.getAllTasks(apiController.user!.uid);
      change(
        _tasks,
        status: RxStatus.success(),
      );
    } catch (e) {
      change(_tasks, status: RxStatus.error(e.toString()));
    }
  }
}
