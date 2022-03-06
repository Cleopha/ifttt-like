import 'package:flutter/material.dart';
import 'package:frontend/controllers/controller_constant.dart';

class PrDetected extends StatefulWidget {
  const PrDetected({
    required this.onSettingsChange,
    required this.params,
    Key? key,
  }) : super(key: key);

  final Function(Map<String, dynamic>) onSettingsChange;
  final Map<String, dynamic> params;

  @override
  State<PrDetected> createState() => _PrDetectedState();
}

class _PrDetectedState extends State<PrDetected> {
  String githubName = '';

  Future<List<String>> _getRepoList() async {
    String token = await apiController.credentialAPI
        .getCredential(apiController.user!.uid, 'GITHUB');
    githubName = await apiController.userAPI.githubName(token);
    return await apiController.userAPI.githubRepos(token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getRepoList(),
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            const Text(
              'Repo à observer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  child: snapshot.hasData
                      ? DropdownButton<String>(
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isExpanded: true,
                          value: widget.params['repo'] != ''
                              ? widget.params['repo']
                              : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              widget.params['repo'] = newValue;
                              widget.params['user'] = githubName;
                            });
                            widget.onSettingsChange(
                              Map<String, dynamic>.from(widget.params)
                                ..addAll(
                                  {
                                    'repo': newValue,
                                    'user': githubName,
                                  },
                                ),
                            );
                          },
                          items: snapshot.data!
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
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: SizedBox(
                              width: 25,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
