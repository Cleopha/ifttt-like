import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(43),
        color: Colors.white,
      ),
      child: const Center(
        child: Text(
          'Ajouter',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
