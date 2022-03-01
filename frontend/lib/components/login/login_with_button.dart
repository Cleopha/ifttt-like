import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginWithButton extends StatelessWidget {
  const LoginWithButton({
    this.onTap,
    required this.pathToIcon,
    required this.text,
    Key? key,
  }) : super(key: key);

  final Function()? onTap;
  final String pathToIcon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(45),
        splashColor: Colors.black.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: BorderRadius.circular(45),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  pathToIcon,
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
