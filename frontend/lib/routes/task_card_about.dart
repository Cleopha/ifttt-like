import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(
              backgroundColor: task.action.service.color,
              elevation: 0,
              leading: TextButton(
                child: SvgPicture.asset(
                  'assets/icons/left-arrow.svg',
                  semanticsLabel: 'personna icon',
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  height: 23,
                  width: 20,
                ),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => print('settings'),
                ),
              ],
            ),
      body: ListView(
        children: [
          Container(
            color: task.action.service.color,
            child: Column(
              children: [
                if (kIsWeb) const _WebAppBar(),
                TaskAboutCore(
                  task: task,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WebAppBar extends StatelessWidget {
  const _WebAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 130, child: TopBar(colorReverse: true)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            ReturnButton(),
            SettingsButton(),
          ],
        )
      ],
    );
  }
}
