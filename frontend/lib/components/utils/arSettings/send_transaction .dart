import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendTransaction extends StatelessWidget {
  const SendTransaction({
    required this.onSettingsChange,
    required this.params,
    Key? key,
  }) : super(key: key);

  final Function(Map<String, dynamic>) onSettingsChange;
  final Map<String, dynamic> params;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Adresse Ethereum du déstinataire',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  focusColor: Colors.transparent,
                ),
                onFieldSubmitted: (newValue) {
                  onSettingsChange(Map<String, dynamic>.from(params)
                    ..addAll({'to': newValue}));
                },
                initialValue: params['to'].toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
        const Text(
          'Quantité',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  focusColor: Colors.transparent,
                ),
                onFieldSubmitted: (newValue) {
                  try {
                    int _newVal = int.parse(newValue);
                    onSettingsChange(Map<String, dynamic>.from(params)
                      ..addAll({'value': _newVal}));
                  } catch (e) {
                    Get.snackbar(
                      'Erreur',
                      'Valeur invalide, il faut que la valeur soit un nombre',
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                keyboardType: TextInputType.number,
                initialValue: params['value'].toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
