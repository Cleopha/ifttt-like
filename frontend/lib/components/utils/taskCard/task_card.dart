import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/routes/task_card_about.dart';

import 'package:frontend/components/utils/taskCard/task_card_bottom.dart';

import 'package:frontend/utils/services.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kIsWeb ? 370 : null,
      decoration: BoxDecoration(
        color: task.isActive ? task.action.service.color : Colors.grey[500],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 7,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashColor: Colors.black.withOpacity(0.2),
          highlightColor: Colors.transparent,
          onTap: () {
            Get.to(
              TaskCardAbout(task: task),
              transition:
                  kIsWeb ? Transition.noTransition : Transition.rightToLeft,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title ?? task.formatedTitle(kIsWeb),
                  style: const TextStyle(
                    fontSize: kIsWeb ? 36 : 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 19),
                Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              'par',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: kIsWeb ? 19 : null,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 7),
                          ],
                        ),
                        Text(
                          task.author,
                          style: TextStyle(
                            fontSize: kIsWeb ? 19 : null,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kIsWeb ? 45 : 19),
                    if (!kIsWeb)
                      Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: FlutterSwitch(
                                  height: 32,
                                  width: 120,
                                  value: task.isActive,
                                  borderRadius: 25,
                                  padding: 4,
                                  activeText: 'Connecté',
                                  inactiveText: 'Connecter',
                                  activeTextColor: Colors.white,
                                  inactiveTextColor: Colors.white,
                                  activeTextFontWeight: FontWeight.w600,
                                  inactiveTextFontWeight: FontWeight.w600,
                                  activeColor: Colors.black.withOpacity(0.5),
                                  inactiveColor: Colors.grey[600]!,
                                  toggleColor: task.isActive
                                      ? task.action.service.color
                                      : Colors.grey[500]!,
                                  showOnOff: true,
                                  onToggle: (bool value) {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 19),
                        ],
                      ),
                    TaskCardBottom(
                      numberOfUsers: task.numberOfUsers,
                      tags: task.tagsGetter(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
