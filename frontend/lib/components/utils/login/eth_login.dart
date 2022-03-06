import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/services.dart';
import 'package:get/get.dart';

class EthLogin extends StatefulWidget {
  const EthLogin({Key? key}) : super(key: key);

  @override
  State<EthLogin> createState() => _EthLoginState();
}

class _EthLoginState extends State<EthLogin> {
  String _key = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Clé de votre compte Ethereum',
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
                onChanged: (s) => setState(() => _key = s),
                initialValue: _key,
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
                await apiController.credentialAPI
                    .createCredential(apiController.user!.uid, "ETH", _key);
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
                  color: services['ethereum']!.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      services['ethereum']!.iconPath,
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Valider la clé',
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
