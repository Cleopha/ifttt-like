import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.title,
    required this.author,
    required this.numberOfUsers,
    required this.tags,
    Key? key,
  }) : super(key: key);

  final String title;
  final String author;
  final int numberOfUsers;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: kIsWeb ? 375 : null,
      decoration: BoxDecoration(
        color: Colors.grey[500],
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
            kIsWeb
                ? title.length > 60
                    ? title.substring(0, 60) + '...'
                    : title
                : title,
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
                            value: false,
                            borderRadius: 25,
                            padding: 4,
                            activeText: 'Connecté',
                            inactiveText: 'Connecter',
                            activeTextColor: Colors.white,
                            inactiveTextColor: Colors.white,
                            activeTextFontWeight: FontWeight.w600,
                            inactiveTextFontWeight: FontWeight.w600,
                            activeColor: Colors.grey[600]!,
                            inactiveColor: Colors.grey[600]!,
                            toggleColor: Colors.grey[500]!,
                            showOnOff: true,
                            onToggle: (bool value) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 19),
                  ],
                ),
              Row(
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
                          '$numberOfUsers',
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
                      for (var tag in tags)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            'assets/icons/tags/$tag.svg',
                            semanticsLabel: '$tag icon',
                            color: Colors.white.withOpacity(kIsWeb ? 0.9 : 0.6),
                            height: 19,
                            width: 16,
                          ),
                        ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
