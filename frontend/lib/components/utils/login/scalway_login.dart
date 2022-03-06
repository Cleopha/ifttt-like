import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/services.dart';
import 'package:get/get.dart';

class ScalewayLogin extends StatefulWidget {
  const ScalewayLogin({Key? key}) : super(key: key);

  @override
  State<ScalewayLogin> createState() => _ScalewayLoginState();
}

class _ScalewayLoginState extends State<ScalewayLogin> {
  String _accessKey = "";
  String _secretKey = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Clé d\'accès',
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
                onChanged: (s) => setState(() => _accessKey = s),
                initialValue: _accessKey,
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
          'Clé secrète',
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
                onChanged: (s) => setState(() => _secretKey = s),
                initialValue: _secretKey,
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              try {
                await apiController.credentialAPI.createCredential(
                  apiController.user!.uid,
                  "SCALEWAY",
                  '$_accessKey+$_secretKey',
                );
                Get.back();
              } catch (e) {
                Get.snackbar(
                  'Erreur',
                  e.toString(),
                  backgroundColor: Colors.red,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            borderRadius: BorderRadius.circular(45),
            splashColor: Colors.black.withOpacity(0.2),
            highlightColor: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: services['scaleway']!.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      services['scaleway']!.iconPath,
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Valider vos identifiants',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
