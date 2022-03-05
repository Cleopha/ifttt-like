import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/components/utils/task_tree.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/routes/task_setting.dart';
import 'package:get/get.dart';

import 'package:frontend/components/home/top_bar.dart';
import 'package:frontend/components/taskCardAbout/return_button.dart';
import 'package:frontend/components/taskCardAbout/settings_button.dart';
import 'package:frontend/components/taskCardAbout/task_about_core.dart';
import 'package:frontend/utils/task.dart';

class TaskCardAbout extends StatelessWidget {
  const TaskCardAbout({
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
                    backgroundColor: task.action!.service.color,
                    elevation: 0,
                    leading: TextButton(
                      child: SvgPicture.asset(
                        'assets/icons/left-arrow.svg',
                        semanticsLabel: 'personna icon',
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        width: 20,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => Get.to(
                          TaskSetting(task: task),
                          transition: kIsWeb
                              ? Transition.noTransition
                              : Transition.rightToLeft,
                        ),
                      ),
                    ],
                  ),
            body: ListView(
              children: [
                Container(
                  color: task.action!.service.color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (kIsWeb) const _WebAppBar(),
                      TaskAboutCore(
                        task: task,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TaskTree(
                    task: task,
                    isEditable: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 45),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await apiController.taskAPI.deleteWorkflow(
                        apiController.user!.uid,
                        task.workflowId!,
                      );
                      Get.back();
                    },
                    child: const Text(
                      'Archiver',
                      style: TextStyle(
                        fontSize: kIsWeb ? 24 : 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
        : Container();
  }
}

class _WebAppBar extends StatelessWidget {
  const _WebAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 130, child: TopBar(colorReverse: true)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ReturnButton(),
              SettingsButton(),
            ],
          ),
        )
      ],
    );
  }
}
