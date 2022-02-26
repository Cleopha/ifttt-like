import 'package:flutter/material.dart';

import 'package:frontend/components/utils/createTask/add_button.dart';

class IfThisButton extends StatelessWidget {
  const IfThisButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.9),
      borderRadius: const BorderRadius.all(Radius.circular(7)),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.transparent,
        onTap: () {
          // Get.to(
          //   TaskCardAbout(task: task),
          //   transition: kIsWeb
          //       ? Transition.noTransition
          //       : Transition.rightToLeft,
          // );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: const Offset(0, 5),
                    child: const Text(
                      'If This',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const AddButton(),
            ],
          ),
        ),
      ),
    );
  }
}
