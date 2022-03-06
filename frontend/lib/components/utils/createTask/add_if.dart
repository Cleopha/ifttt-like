import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/components/utils/createTask/service_about.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:frontend/utils/services.dart';
import 'package:get/get.dart';

class AddIf extends StatelessWidget {
  const AddIf({Key? key}) : super(key: key);

  Future<List<String>> _getAvailableServices() async {
    final List<String> services = ['nist'];
    await apiController.credentialAPI
        .getCredential(apiController.user!.uid, 'GITHUB')
        .then((_) => services.add('github'))
        .catchError((_) {});
    await apiController.credentialAPI
        .getCredential(apiController.user!.uid, 'GOOGLE')
        .then((_) => services.add('google'))
        .catchError((_) {});
    await apiController.credentialAPI
        .getCredential(apiController.user!.uid, 'COINMARKET')
        .then((_) => services.add('coinmarketcap'))
        .catchError((_) {});
    await apiController.credentialAPI
        .getCredential(apiController.user!.uid, 'SCALEWAY')
        .then((_) => services.add('scaleway'))
        .catchError((_) {});
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _getAvailableServices(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: TextButton(
                child: SvgPicture.asset(
                  'assets/icons/left-arrow.svg',
                  alignment: Alignment.centerLeft,
                  color: Colors.black,
                  width: 20,
                ),
                onPressed: () => Get.back(result: null),
              ),
              title: const Text(
                'Séléctioner le service desiré',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            body: snapshot.hasData
                ? SingleChildScrollView(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 16),
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            children: [
                              for (String _key in services.keys)
                                if (actions.values.any((a) =>
                                    a.service.name == services[_key]!.name))
                                  SizedBox(
                                    height: 140,
                                    child: Material(
                                      color: snapshot.data!.contains(_key)
                                          ? services[_key]!.color
                                          : Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        onTap: !snapshot.data!.contains(_key)
                                            ? null
                                            : () async {
                                                final FlowAR? flow =
                                                    await Get.to(
                                                  ServiceAbout(
                                                    service: services[_key]!,
                                                  ),
                                                );
                                                if (flow == null) return;
                                                Get.back(result: flow);
                                              },
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        splashColor:
                                            Colors.black.withOpacity(0.2),
                                        highlightColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 8,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                services[_key]!.iconPath,
                                                alignment: Alignment.center,
                                                color: !snapshot.data!
                                                        .contains(_key)
                                                    ? Colors.black
                                                        .withOpacity(0.2)
                                                    : Colors.white,
                                                height: 60,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                services[_key]!.name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: !snapshot.data!
                                                          .contains(_key)
                                                      ? Colors.black
                                                          .withOpacity(0.2)
                                                      : Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        });
  }
}