import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(43),
          color: kIsWeb ? Colors.black : Colors.white24,
        ),
        child: const Center(
          child: Text(
            'Créer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}