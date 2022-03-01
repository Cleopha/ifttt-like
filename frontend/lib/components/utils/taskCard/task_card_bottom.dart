import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskCardBottom extends StatelessWidget {
  const TaskCardBottom({
    Key? key,
    required this.numberOfUsers,
    required this.tags,
  }) : super(key: key);

  final int numberOfUsers;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/person.svg',
              semanticsLabel: 'personna icon',
              alignment: Alignment.centerLeft,
              color: Colors.white.withOpacity(kIsWeb ? 0.9 : 0.6),
              height: 19,
              width: 16,
            ),
            const SizedBox(width: 8),
            Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(top: (kIsWeb ? 8 : 0)),
              child: Text(
                numberOfUsers > 1000
                    ? '${(numberOfUsers / 1000).toStringAsFixed(1)}k'
                    : numberOfUsers.toString(),
                style: TextStyle(
                  fontSize: kIsWeb ? 19 : null,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(kIsWeb ? 0.9 : 0.6),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            for (var tag in tags.toSet().toList())
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
