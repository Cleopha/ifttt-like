import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController with StateMixin<List<Task>> {
  static TaskController instance = Get.find();

  List<Task> _tasks = <Task>[];

  Future<void> getTasks() async {
    if (apiController.user == null) {
      change(_tasks, status: RxStatus.error('You are not logged in'));
    }
    change(_tasks, status: RxStatus.loading());

    try {
      _tasks = await apiController.taskAPI.getAllTasks(apiController.user!.uid);
      if (_tasks.isEmpty) {
        change(_tasks, status: RxStatus.empty());
      } else {
        change(
          _tasks,
          status: RxStatus.success(),
        );
      }
    } catch (e) {
      change(_tasks, status: RxStatus.error(e.toString()));
    }
  }
}
