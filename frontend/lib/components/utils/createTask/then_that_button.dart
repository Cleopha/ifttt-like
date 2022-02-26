import 'package:flutter/material.dart';
import 'package:frontend/components/utils/createTask/add_button.dart';

class ThenThatButton extends StatelessWidget {
  const ThenThatButton({
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(enabled ? 0.9 : 0.4),
      borderRadius: const BorderRadius.all(Radius.circular(7)),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.transparent,
        onTap: enabled
            ? () {
                // Get.to(
                //   TaskCardAbout(task: task),
                //   transition: kIsWeb
                //       ? Transition.noTransition
                //       : Transition.rightToLeft,
                // );
              }
            : null,
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
                    child: Text(
                      'Then That',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: enabled ? 38 : 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              if (enabled) const AddButton(),
            ],
          ),
        ),
      ),
    );
  }
}
