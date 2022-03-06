import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/services.dart';

class ServiceAbout extends StatelessWidget {
  const ServiceAbout({
    this.isReaction = false,
    required this.service,
    Key? key,
  }) : super(key: key);

  final bool isReaction;
  final ServiceInfo service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(
              backgroundColor: service.color,
              elevation: 0,
              leading: TextButton(
                child: SvgPicture.asset(
                  'assets/icons/left-arrow.svg',
                  semanticsLabel: 'personna icon',
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  width: 20,
                ),
                onPressed: () => Get.back(),
              ),
              title: const Text(
                'Séléctioner le déclancheur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      body: ListView(
        children: [
          Container(
            color: service.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    service.iconPath,
                    color: Colors.white,
                    width: 90,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    service.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    service.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  kIsWeb ? (MediaQuery.of(context).size.width / 2.7) : 12,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isReaction)
                  for (String _key in actions.keys)
                    if (actions[_key]!.service.name == service.name)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _ASelector(id: _key, action: actions[_key]!),
                      ),
                if (isReaction)
                  for (String _key in reactions.keys)
                    if (reactions[_key]!.service.name == service.name)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _RSelector(id: _key, reaction: reactions[_key]!),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ASelector extends StatelessWidget {
  const _ASelector({
    required this.action,
    required this.id,
    Key? key,
  }) : super(key: key);

  final ActionInfo action;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            blurRadius: 7,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: action.service.color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.transparent,
          onTap: () {
            Get.back(result: FlowAR(flow: id, params: action.params));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Transform.translate(
              offset: const Offset(0, 2),
              child: Text(
                action.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RSelector extends StatelessWidget {
  const _RSelector({
    required this.reaction,
    required this.id,
    Key? key,
  }) : super(key: key);

  final ReactionInfo reaction;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            blurRadius: 7,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: reaction.service.color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.transparent,
          onTap: () {
            Get.back(result: FlowAR(flow: id, params: reaction.params));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Transform.translate(
              offset: const Offset(0, 2),
              child: Text(
                reaction.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
