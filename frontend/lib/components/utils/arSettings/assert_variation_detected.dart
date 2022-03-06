import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssertVariationDetected extends StatelessWidget {
  const AssertVariationDetected({
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
          'Limite de Varaition',
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
                onFieldSubmitted: (newWeight) {
                  try {
                    double _newVal = double.parse(newWeight);
                    if (_newVal < 0 || _newVal > 100) {
                      throw Exception('Invalid value');
                    }
                    onSettingsChange(<String, dynamic>{
                      'limit': _newVal,
                    });
                  } catch (e) {
                    Get.snackbar(
                      'Erreur',
                      'Valeur invalide, il faut une valeur entre 0 et 100',
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                keyboardType: TextInputType.number,
                initialValue: params['limit'].toString(),
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
