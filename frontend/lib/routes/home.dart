import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:frontend/components/home/top_bar.dart';
import 'package:frontend/components/utils/create_button.dart';
import 'package:frontend/components/utils/taskCard/task_card.dart';
import 'package:frontend/components/utils/task_scroller.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/task.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        taskController.getTasks();
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                CustomScrollView(
                  slivers: <Widget>[
                    const SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      expandedHeight: 130,
                      collapsedHeight: 60,
                      backgroundColor: Colors.white,
                      flexibleSpace: Center(
                        child: TopBar(),
                      ),
                    ),
                    taskController.obx(
                      (state) {
                        List<Task> _filtredTask = state!
                            .where((task) => task.action != null)
                            .toList();
                        return SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget>[
                              TaskScroller(
                                tasks: [
                                  for (Task _task in _filtredTask)
                                    TaskCard(
                                      task: _task,
                                    ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      onEmpty: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Center(
                              child: SizedBox(
                                width: 300,
                                child: Text(
                                  'Il semblerait que tu n\'as pas encore de tâches, crées-en une !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onLoading: SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: const Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: !kIsWeb
                ? Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Expanded(
                          child: CreateButton(),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
