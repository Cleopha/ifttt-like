import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginWithButton extends StatelessWidget {
  const LoginWithButton({
    this.active = true,
    this.onTap,
    required this.pathToIcon,
    required this.text,
    Key? key,
  }) : super(key: key);

  final Function()? onTap;
  final String pathToIcon;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 30 : 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: active ? onTap : null,
          borderRadius: BorderRadius.circular(kIsWeb ? 10 : 45),
          splashColor: Colors.black.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: double.infinity,
            height: kIsWeb ? 70 : 50,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(kIsWeb ? 15 : 45),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    pathToIcon,
                    height: 30,
                    width: 30,
                    color:
                        active ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: kIsWeb ? 24 : 16,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
