import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:frontend/components/utils/explore_button.dart';
import 'package:frontend/controllers/controller_constant.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    this.colorReverse = false,
    Key? key,
  }) : super(key: key);

  final bool colorReverse;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  semanticsLabel: 'IFTTT Like Logo',
                  alignment: Alignment.centerLeft,
                  height: kIsWeb ? 47 : 37,
                  color: colorReverse ? Colors.white : Colors.black,
                ),
                if (kIsWeb)
                  SizedBox(
                    width: 432,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ExploreButton(colorReverse: colorReverse),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 9),
              child: Text(
                apiController.user!.email.length > 20
                    ? apiController.user!.email.substring(0, 20) + '...'
                    : apiController.user!.email,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: kIsWeb ? 20 : 13,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                  overflow: TextOverflow.ellipsis,
                  color: colorReverse ? Colors.white : Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
