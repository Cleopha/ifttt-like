import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/utils/task_tree.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

class TaskSetting extends StatelessWidget {
  const TaskSetting({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return task.action != null
        ? Scaffold(
            appBar: kIsWeb
                ? null
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: TextButton(
                      child: SvgPicture.asset(
                        'assets/icons/left-arrow.svg',
                        semanticsLabel: 'personna icon',
                        alignment: Alignment.centerLeft,
                        color: Colors.black,
                        width: 20,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    title: const Text(
                      'Modifier l\'Applet',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  TaskTree(task: task),
                ],
              ),
            ),
          )
        : Container();
  }
}
