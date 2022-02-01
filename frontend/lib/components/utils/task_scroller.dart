import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:frontend/components/utils/taskCard/task_card.dart';

class TaskScroller extends StatelessWidget {
  const TaskScroller({
    required this.tasks,
    Key? key,
  }) : super(key: key);

  final List<TaskCard> tasks;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: kIsWeb ? (MediaQuery.of(context).size.width / 5.4) : 15,
            right: kIsWeb ? (MediaQuery.of(context).size.width / 5.4) : 15,
            top: 15,
            bottom: 7,
          ),
          child: StaggeredGrid.count(
            crossAxisCount: kIsWeb ? 3 : 1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: tasks,
          ),
        ),
      ],
    );
  }
}
