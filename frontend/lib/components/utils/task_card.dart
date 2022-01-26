import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rolling_switch/rolling_switch.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      width: !kIsWeb ? double.infinity : null,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 7,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get a notification when your battery is low',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          // RollingSwitch.icon(
          //   onChanged: (bool state) {},
          //   circularColor: Colors.grey[400]!,
          //   rollingInfoRight: const RollingIconInfo(
          //     backgroundColor: Colors.black38,
          //     text: Text('Flag'),
          //   ),
          //   rollingInfoLeft: const RollingIconInfo(
          //     backgroundColor: Colors.black38,
          //     text: Text(
          //       'Connecter',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 17,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
