import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:frontend/components/utils/create_button.dart';
import 'package:frontend/components/utils/explore_button.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 50),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    semanticsLabel: 'IFTTT Like Logo',
                    height: kIsWeb ? 50 : 37,
                  ),
                  if (kIsWeb)
                    SizedBox(
                      width: 432,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          Expanded(
                            child: ExploreButton(),
                          ),
                          Expanded(
                            child: CreateButton(),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          const Text(
            'quentin.fringhian@gmail.com',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: kIsWeb ? 20 : 13,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
