import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/utils/createTask/add_button.dart';
import 'package:frontend/components/utils/createTask/add_then.dart';
import 'package:frontend/controllers/edit_task_controller.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:get/get.dart';

class ThenThatButton extends StatefulWidget {
  const ThenThatButton({
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  final bool enabled;

  @override
  State<ThenThatButton> createState() => _ThenThatButtonState();
}

class _ThenThatButtonState extends State<ThenThatButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditTaskController>(
      builder: (editTask) {
        return Material(
          color: Colors.black.withOpacity(widget.enabled ? 0.9 : 0.4),
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.transparent,
            onTap: widget.enabled
                ? () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final FlowAR? newFlow = await Get.to(
                      const AddThen(),
                      transition: kIsWeb
                          ? Transition.noTransition
                          : Transition.rightToLeft,
                    );
                    if (newFlow != null) {
                      try {
                        await editTask.addThenThat(newFlow);
                      } catch (e) {
                        Get.snackbar(
                          'Erreur',
                          e.toString().split('\n')[0],
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 15,
              ),
              child: _isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
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
                                  fontSize: widget.enabled ? 38 : 48,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.enabled) const AddButton(),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
