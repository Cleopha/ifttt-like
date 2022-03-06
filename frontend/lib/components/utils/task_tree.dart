import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/controllers/edit_task_controller.dart';
import 'package:frontend/routes/task_setting.dart';

import 'package:frontend/utils/task.dart';

import 'package:frontend/components/utils/createTask/if_this_button.dart';
import 'package:frontend/components/utils/createTask/then_that_button.dart';
import 'package:get/get.dart';

class TaskTree extends StatefulWidget {
  const TaskTree({
    required this.task,
    this.isEditable = true,
    Key? key,
  }) : super(key: key);

  final Task task;
  final bool isEditable;

  @override
  State<TaskTree> createState() => _TaskTreeState();
}

class _TaskTreeState extends State<TaskTree> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditTaskController>(
      init: EditTaskController(task: widget.task),
      builder: (editTask) {
        Get.lazyPut(() => EditTaskController(task: widget.task));
        return Column(
          children: [
            const SizedBox(height: 16),
            if (editTask.task.author != null && widget.isEditable)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Créée par ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    editTask.task.author!.length > 30
                        ? '${editTask.task.author!.substring(0, 30)}...'
                        : editTask.task.author!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            if (editTask.task.author != null) const SizedBox(height: 15),
            if (editTask.task.action == null && widget.isEditable)
              const IfThisButton(),
            if (editTask.task.action != null)
              _TaskServiceViewer(
                isAction: true,
                color: editTask.task.action!.service.color,
                title: editTask.task.action!.name,
                iconPath: editTask.task.action!.service.iconPath,
                onClick: !widget.isEditable
                    ? null
                    : () async {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Material(
                                color: editTask.task.action!.service.color,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                    left: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      SvgPicture.asset(
                                        editTask.task.action!.service.iconPath,
                                        semanticsLabel: 'icon',
                                        alignment: Alignment.centerLeft,
                                        color: Colors.white,
                                        width: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            editTask.task.action!.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: editTask.task.action!.settings(
                                      (
                                        Map<String, dynamic> newParams,
                                      ) async {
                                        try {
                                          setState(() {
                                            editTask.task.action!.params =
                                                newParams;
                                          });
                                          await apiController.taskAPI.putAction(
                                            apiController.user!.uid,
                                            editTask.task.workflowId!,
                                            editTask.task.action!,
                                          );
                                        } catch (e) {
                                          Get.snackbar(
                                            'Erreur',
                                            e.toString().split('\n')[0],
                                            backgroundColor: Colors.red,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                                      editTask.task.action!.params,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      'Changer l\'action',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
              ),
            const _ServiceSeparator(),
            for (final reaction in editTask.task.reactions)
              Column(
                children: [
                  _TaskServiceViewer(
                    isAction: false,
                    color: reaction.service.color,
                    title: reaction.name,
                    iconPath: reaction.service.iconPath,
                    onClick: !widget.isEditable
                        ? null
                        : () async {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: Material(
                                    color: reaction.service.color,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(7)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12.0,
                                        bottom: 12.0,
                                        left: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          SvgPicture.asset(
                                            reaction.service.iconPath,
                                            semanticsLabel: 'icon',
                                            alignment: Alignment.centerLeft,
                                            color: Colors.white,
                                            height: 24,
                                            width: 16,
                                          ),
                                          const SizedBox(width: 10),
                                          Transform.translate(
                                            offset: const Offset(0, 1),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                reaction.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Center(
                                        child: reaction.settings(
                                          (
                                            Map<String, dynamic> newParams,
                                          ) async {
                                            try {
                                              setState(() {
                                                reaction.params = newParams;
                                              });
                                              await apiController.taskAPI
                                                  .putReaction(
                                                apiController.user!.uid,
                                                reaction.workflowId,
                                                reaction,
                                              );
                                            } catch (e) {
                                              Get.snackbar(
                                                'Erreur',
                                                e.toString().split('\n')[0],
                                                backgroundColor: Colors.red,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            }
                                          },
                                          reaction.params,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Material(
                                        child: InkWell(
                                          onTap: () async {
                                            try {
                                              await apiController.taskAPI
                                                  .deleteReaction(
                                                apiController.user!.uid,
                                                reaction.workflowId,
                                                widget.task,
                                                reaction,
                                              );
                                            } catch (e) {
                                              Get.snackbar(
                                                'Erreur',
                                                e.toString().split('\n')[0],
                                                backgroundColor: Colors.red,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Supprimer la reaction',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                  ),
                  const _ServiceSeparator(),
                ],
              ),
            if (widget.isEditable)
              ThenThatButton(enabled: editTask.task.action != null),
            if (!widget.isEditable)
              GestureDetector(
                onTap: () => Get.to(
                  TaskSetting(task: widget.task),
                  transition:
                      kIsWeb ? Transition.noTransition : Transition.rightToLeft,
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _ServiceSeparator extends StatelessWidget {
  const _ServiceSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 7,
        height: 37,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
          ),
        ),
      ),
    );
  }
}

class _TaskServiceViewer extends StatelessWidget {
  const _TaskServiceViewer({
    required this.isAction,
    required this.color,
    required this.title,
    required this.iconPath,
    this.onClick,
    Key? key,
  }) : super(key: key);

  final bool isAction;
  final Color color;
  final String title;
  final String iconPath;
  final void Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(7)),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.transparent,
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            bottom: 12.0,
            left: 15,
          ),
          child: Row(
            children: [
              Transform.translate(
                offset: const Offset(0, 1),
                child: Text(
                  isAction ? 'If' : 'Then',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                iconPath,
                semanticsLabel: 'icon',
                alignment: Alignment.centerLeft,
                color: Colors.white,
                height: 24,
                width: 16,
              ),
              const SizedBox(width: 10),
              Transform.translate(
                offset: const Offset(0, 1),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
