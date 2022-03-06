import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/utils/task.dart';

class TaskAboutCore extends StatelessWidget {
  const TaskAboutCore({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? (MediaQuery.of(context).size.width / 2.7) : 35,
            vertical: 15,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  for (var tag in task.tagsGetter().toSet().toList())
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: SvgPicture.asset(
                        tag,
                        semanticsLabel: '$tag icon',
                        color: Colors.white,
                        width: task.tagsGetter().toSet().length > 3 ? 48 : 64,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 19),
              Text(
                task.title ?? task.formatedTitle(false),
                style: const TextStyle(
                  fontSize: kIsWeb ? 47 : 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? (MediaQuery.of(context).size.width / 2.7) : 26,
            vertical: 14,
          ),
          child: Row(
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
                task.author ?? 'IFTTT Like',
                style: TextStyle(
                  fontSize: kIsWeb ? 19 : null,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
