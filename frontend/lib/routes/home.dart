import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:frontend/components/home/top_bar.dart';
import 'package:frontend/components/utils/create_button.dart';
import 'package:frontend/components/utils/explore_button.dart';
import 'package:frontend/components/utils/task_card.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBar(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: kIsWeb ? (MediaQuery.of(context).size.width / 5) : 15,
                    right:
                        kIsWeb ? (MediaQuery.of(context).size.width / 5) : 15,
                    top: 15,
                  ),
                  child: GridView.count(
                    crossAxisCount: kIsWeb ? 2 : 1,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: const [
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                      TaskCard(),
                    ],
                  ),
                ),
              ),
              if (!kIsWeb)
                Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
