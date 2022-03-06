import 'package:flutter/material.dart';

class CreateNewPage extends StatelessWidget {
  const CreateNewPage({
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
          'Nom de la page a créer',
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
                    ..addAll({'title': newValue}));
                },
                initialValue: params['title'].toString(),
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
          'Nom de la page parente',
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
                    ..addAll({'from': newValue}));
                },
                initialValue: params['from'].toString(),
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
