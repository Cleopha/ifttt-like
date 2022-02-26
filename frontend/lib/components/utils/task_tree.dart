import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:frontend/utils/task.dart';

import 'package:frontend/components/utils/createTask/if_this_button.dart';
import 'package:frontend/components/utils/createTask/then_that_button.dart';

class TaskTree extends StatelessWidget {
  const TaskTree({
    required this.task,
    Key? key,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (task.author != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Créée par ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                '${task.author}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        if (task.author != null) const SizedBox(height: 15),
        if (task.action == null) const IfThisButton(),
        if (task.action != null)
          _TaskServiceViewer(
            isAction: true,
            color: task.action!.service.color,
            title: task.action!.name,
            iconPath: task.action!.service.iconPath,
            onClick: () {},
          ),
        const _ServiceSeparator(),
        for (final reaction in task.reactions)
          Column(
            children: [
              _TaskServiceViewer(
                isAction: false,
                color: reaction.service.color,
                title: reaction.name,
                iconPath: reaction.service.iconPath,
              ),
              const _ServiceSeparator(),
            ],
          ),
        ThenThatButton(enabled: task.action != null),
      ],
    );
  }
}

class _ServiceSeparator extends StatelessWidget {
  const _ServiceSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 7,
        height: 37,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
          ),
        ),
      ),
    );
  }
}

class _TaskServiceViewer extends StatelessWidget {
  const _TaskServiceViewer({
    required this.isAction,
    required this.color,
    required this.title,
    required this.iconPath,
    this.onClick,
    Key? key,
  }) : super(key: key);

  final bool isAction;
  final Color color;
  final String title;
  final String iconPath;
  final void Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(7)),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.transparent,
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 15,
          ),
          child: Row(
            children: [
              Transform.translate(
                offset: const Offset(0, 1),
                child: Text(
                  isAction ? 'If' : 'Then',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                iconPath,
                semanticsLabel: 'icon',
                alignment: Alignment.centerLeft,
                color: Colors.white,
                height: 19,
                width: 16,
              ),
              const SizedBox(width: 10),
              Transform.translate(
                offset: const Offset(0, 1),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
