import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExploreMenu extends StatelessWidget {
  const ExploreMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (kIsWeb)
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: const Text(
              'Explorer',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        if (!kIsWeb)
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 10),
            width: 23,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.black,
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        ),
      ],
    );
  }
}
