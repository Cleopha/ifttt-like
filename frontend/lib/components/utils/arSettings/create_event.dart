import 'package:flutter/material.dart';

class CreateNewEvent extends StatelessWidget {
  const CreateNewEvent({
    required this.onSettingsChange,
    required this.params,
    Key? key,
  }) : super(key: key);

  final Function(Map<String, dynamic>) onSettingsChange;
  final Map<String, dynamic> params;

  Future<void> _androidCalandar({
    required BuildContext context,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return child!;
      },
      initialDate: DateTime.parse(params["start"]),
      firstDate: DateTime.parse(params["start"]),
      lastDate: DateTime.parse(params["start"]).add(const Duration(days: 365)),
    );
    if (picked != null) {
      final String date = picked.toIso8601String();
      onSettingsChange(
        Map<String, dynamic>.from(params)
          ..addAll(
            {'start': date},
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Nom de l\'event',
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
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Text(
              params['start'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          onPressed: () => _androidCalandar(context: context),
        ),
      ],
    );
  }
}
