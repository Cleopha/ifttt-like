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
        Row(
          children: [
            for (var tag in task.tagsGetter().toSet().toList())
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: SvgPicture.asset(
                  tag,
                  semanticsLabel: '$tag icon',
                  color: Colors.white.withOpacity(kIsWeb ? 0.9 : 0.6),
                  height: 19,
                  width: 16,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
