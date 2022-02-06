import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 2.5,
            color: Colors.white.withOpacity(0.5),
          ),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/left-arrow-simple.svg',
              semanticsLabel: 'personna icon',
              alignment: Alignment.centerLeft,
              color: Colors.white,
              height: 10,
              width: 14,
            ),
            const SizedBox(width: 10),
            const Text(
              'Retour',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
