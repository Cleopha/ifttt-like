import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/utils/services.dart';

class ServiceAbout extends StatelessWidget {
  const ServiceAbout({
    required this.service,
    Key? key,
  }) : super(key: key);

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    service.iconPath,
                    color: Colors.white,
                    width: 110,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  kIsWeb ? (MediaQuery.of(context).size.width / 2.7) : 45,
              vertical: 32,
            ),
            child: Container(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
