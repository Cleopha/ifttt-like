import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:frontend/components/utils/taskCard/task_card.dart';
import 'package:frontend/utils/services.dart';

class TaskScroller extends StatelessWidget {
  const TaskScroller({
    Key? key,
  }) : super(key: key);

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
            children: [
              TaskCard(
                author: 'quentinFringhian',
                numberOfUsers: 3,
                action: actions['prMerge']!,
                reactions: [
                  reactions['openIssue']!,
                  reactions['sendMessage']!,
                  reactions['sendMessage']!,
                ],
                isActive: true,
              ),
              TaskCard(
                author: 'quentinFringhian',
                numberOfUsers: 30000,
                action: actions['xHours']!,
                reactions: [
                  reactions['sendMessage']!,
                ],
                isActive: true,
              ),
              TaskCard(
                author: 'quentinFringhian',
                numberOfUsers: 2875,
                action: actions['folderChange']!,
                reactions: [
                  reactions['sendMessage']!,
                  reactions['openIssue']!,
                ],
                isActive: true,
              ),
              TaskCard(
                author: 'quentinFringhian',
                numberOfUsers: 2875,
                action: actions['specificRole']!,
                reactions: [
                  reactions['sendMessage']!,
                  reactions['addRole']!,
                ],
                isActive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
