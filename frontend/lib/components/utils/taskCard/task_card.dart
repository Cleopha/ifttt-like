import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:frontend/components/utils/taskCard/task_card_bottom.dart';

import 'package:frontend/utils/services.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.author,
    required this.numberOfUsers,
    required this.action,
    required this.reactions,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  final String author;
  final int numberOfUsers;
  final ActionInfo action;
  final List<ReactionInfo> reactions;
  final bool isActive;

  String titleFormator() {
    String finalTitle = 'If ${action.name} Then ';

    for (int i = 0; i < reactions.length; i++) {
      finalTitle += reactions[i].name;
      if (i != reactions.length - 1) {
        finalTitle += ' And ';
      }
    }
    if (kIsWeb && finalTitle.length > 60) {
      finalTitle = finalTitle.substring(0, 60) + '...';
    }
    return finalTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: kIsWeb ? 370 : null,
      decoration: BoxDecoration(
        color: isActive ? action.service.color : Colors.grey[500],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleFormator(),
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
                  if (!kIsWeb)
                    Row(
                      children: [
                        Text(
                          'par',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],
                    ),
                  Text(
                    author,
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
                            value: isActive,
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
                            toggleColor: isActive
                                ? action.service.color
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
                numberOfUsers: numberOfUsers,
                tags: [action.service.iconPath] +
                    reactions
                        .map((reaction) => reaction.service.iconPath)
                        .toList(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
