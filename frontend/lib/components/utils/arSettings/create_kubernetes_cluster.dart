import 'package:flutter/material.dart';

class CreateKubernetesCluster extends StatelessWidget {
  const CreateKubernetesCluster({
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
          'Nom du cluster',
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
          'Région du cluster',
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                isExpanded: true,
                value: params['region'],
                onChanged: (String? newValue) {
                  onSettingsChange(Map<String, dynamic>.from(params)
                    ..addAll({'region': newValue}));
                },
                items: <String>['fr-par', 'nl-ams', 'pl-waw']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const Text(
          'Type de CNI',
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                isExpanded: true,
                value: params['cni'],
                onChanged: (String? newValue) {
                  onSettingsChange(Map<String, dynamic>.from(params)
                    ..addAll({'cni': newValue}));
                },
                items: <String>[
                  'unknown_cni',
                  'cilium',
                  'calico',
                  'weave',
                  'flannel',
                  'kilo',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const Text(
          'Type de controlleur Ingress',
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                isExpanded: true,
                value: params['ingress'],
                onChanged: (String? newValue) {
                  onSettingsChange(Map<String, dynamic>.from(params)
                    ..addAll({'ingress': newValue}));
                },
                items: <String>[
                  'unknown_ingress',
                  'none',
                  'nginx',
                  'traefik',
                  'traefik2',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
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
