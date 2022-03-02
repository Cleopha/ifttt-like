import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/utils/createTask/service_about.dart';
import 'package:frontend/sdk/workflow.dart';
import 'package:frontend/utils/services.dart';
import 'package:get/get.dart';

class AddThen extends StatelessWidget {
  const AddThen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  for (String _key in services.keys)
                    SizedBox(
                      height: 140,
                      child: Material(
                        color: services[_key]!.color,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () async {
                            final FlowAR? flow = await Get.to(
                              ServiceAbout(
                                service: services[_key]!,
                                isReaction: true,
                              ),
                            );
                            if (flow == null) return;
                            Get.back(result: flow);
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          splashColor: Colors.black.withOpacity(0.2),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  services[_key]!.iconPath,
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  width: 50,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  services[_key]!.name,
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
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
