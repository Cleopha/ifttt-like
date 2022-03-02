import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:frontend/components/utils/createTask/add_button.dart';
import 'package:frontend/components/utils/createTask/add_if.dart';
import 'package:frontend/controllers/edit_task_controller.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:get/get.dart';

class IfThisButton extends StatelessWidget {
  const IfThisButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditTaskController>(
      builder: (editTask) {
        return Material(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.transparent,
            onTap: () async {
              final FlowAR? newFlow = await Get.to(
                const AddIf(),
                transition:
                    kIsWeb ? Transition.noTransition : Transition.rightToLeft,
              );
              if (newFlow == null) return;
              try {
                await editTask.setIfThis(newFlow);
              } catch (e) {
                Get.snackbar(
                  'Erreur',
                  e.toString().split('\n')[0],
                  backgroundColor: Colors.red,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
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
      },
    );
  }
}
