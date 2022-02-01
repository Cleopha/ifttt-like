import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:frontend/components/home/top_bar.dart';
import 'package:frontend/components/utils/create_button.dart';
import 'package:frontend/components/utils/explore_button.dart';
import 'package:frontend/components/utils/task_scroller.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[const TaskScroller()],
                  ),
                )
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
                    Expanded(
                      child: ExploreButton(),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
