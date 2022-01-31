import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:frontend/components/home/top_bar.dart';
import 'package:frontend/components/utils/create_button.dart';
import 'package:frontend/components/utils/explore_button.dart';
import 'package:frontend/components/utils/task_card.dart';

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
                    <Widget>[
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: kIsWeb
                                  ? (MediaQuery.of(context).size.width / 5.4)
                                  : 15,
                              right: kIsWeb
                                  ? (MediaQuery.of(context).size.width / 5.4)
                                  : 15,
                              top: 15,
                              bottom: 7,
                            ),
                            child: StaggeredGrid.count(
                              crossAxisCount: kIsWeb ? 3 : 1,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              children: const [
                                TaskCard(
                                  title: 'DJ Roomba',
                                  author: 'IRobot',
                                  numberOfUsers: 3,
                                  tags: ['github', 'notification'],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
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
