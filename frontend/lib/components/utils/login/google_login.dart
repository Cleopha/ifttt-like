import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/services.dart';
import 'package:get/get.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({Key? key}) : super(key: key);

  Future<void> _login() async {
    try {
      OAuth2Helper helper = OAuth2Helper(
        GoogleOAuth2Client(
            redirectUri: 'com.example.frontend:/home',
            customUriScheme: 'com.example.frontend'),
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId:
            '301365716393-pk7ibos2ljlva6sp8dbgqtdcrjvb71o8.apps.googleusercontent.com',
        scopes: [
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/bigquery',
          'https://www.googleapis.com/auth/blogger',
          'https://www.googleapis.com/auth/calendar.events',
          'https://www.googleapis.com/auth/documents',
          'https://www.googleapis.com/auth/spreadsheets'
        ],
      );

      AccessTokenResponse? token = await helper.getTokenFromStorage();

      if (token != null && token.accessToken != null) {
        await apiController.credentialAPI.createCredential(
            apiController.user!.uid, "GOOGLE", token.accessToken!);
      }

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString().split('\n')[0],
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _login,
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
              color: services['google']!.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/google.svg',
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Continuer avec Google',
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
    );
  }
}
