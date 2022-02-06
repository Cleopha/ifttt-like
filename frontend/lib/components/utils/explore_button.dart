import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ExploreButton extends StatelessWidget {
  const ExploreButton({
    this.colorReverse = false,
    Key? key,
  }) : super(key: key);

  final bool colorReverse;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
