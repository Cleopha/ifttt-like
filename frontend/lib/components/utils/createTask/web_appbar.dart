import 'package:flutter/material.dart';

import 'package:frontend/components/utils/cancel_button.dart';

class WebAppBar extends StatelessWidget {
  const WebAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(38),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CancelButton(),
              Text(
                'Créez votre Applet',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 63,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 180),
            ],
          ),
        )
      ],
    );
  }
}
