import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateDatabase extends StatelessWidget {
  const CreateDatabase({
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
          'Nom de la base de données',
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
                    ..addAll({'name': newValue}));
                },
                initialValue: params['name'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const Text(
          'ID du projet',
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
                    ..addAll({'projectID': newValue}));
                },
                initialValue: params['projectID'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const Text(
          'Nom de l\'utilisateur',
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
                    ..addAll({'username': newValue}));
                },
                initialValue: params['username'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const Text(
          'Mot de passe de l\'utilisateur',
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
                  if (newValue.length < 10 ||
                      !newValue.contains(RegExp(r'[0-9]')) ||
                      !newValue.contains(RegExp(r'[A-Z]')) ||
                      !newValue.contains(RegExp(r'[a-z]')) ||
                      !newValue.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    Get.snackbar(
                      'Erreur',
                      'Valeur invalide, il faut que le mot de passe soit composé de 10 caractères minimum,a vec au moins une majuscule, une minuscule, un chiffre et un caractère spécial',
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                  onSettingsChange(Map<String, dynamic>.from(params)
                    ..addAll({'password': newValue}));
                },
                initialValue: params['password'].toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const Text(
          'Type de base de données',
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
              child: DropdownButton<String>(
                value: params['engine'],
                onChanged: (String? newValue) {
                  onSettingsChange(Map<String, dynamic>.from(params)
                    ..addAll({'engine': newValue}));
                },
                items: <String>['PostgreSQL-14', 'MySQL-8']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
