import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/utils/task_tree.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

import 'package:frontend/components/utils/createTask/web_appbar.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final Task newTask = Task(
    reactions: [],
    numberOfUsers: 0,
    isActive: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Créez votre Applet',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            if (kIsWeb) const WebAppBar(),
            TaskTree(task: newTask),
          ],
        ),
      ),
    );
  }
}
