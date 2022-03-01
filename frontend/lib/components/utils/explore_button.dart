import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:frontend/components/home/explore_menu.dart';

class ExploreButton extends StatelessWidget {
  const ExploreButton({
    this.colorReverse = false,
    Key? key,
  }) : super(key: key);

  final bool colorReverse;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const ExploreMenu(),
          isScrollControlled: true,
          enableDrag: !kIsWeb,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          backgroundColor: Colors.white,
          barrierColor: kIsWeb ? Colors.transparent : null,
          constraints: BoxConstraints(
            maxHeight: kIsWeb
                ? MediaQuery.of(context).size.height - 130
                : MediaQuery.of(context).size.height * 0.95,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(43),
          color: kIsWeb
              ? (colorReverse ? Colors.white : Colors.black)
              : Colors.white24,
        ),
        child: Center(
          child: Text(
            'Explorer',
            style: TextStyle(
              color: colorReverse ? Colors.black : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
