import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/services.dart';
import 'package:get/get.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class GithubLogin extends StatelessWidget {
  const GithubLogin({Key? key}) : super(key: key);

  Future<void> _login() async {
    try {
      OAuth2Helper helper = OAuth2Helper(
        GitHubOAuth2Client(
            redirectUri: 'com.example.frontend://home',
            customUriScheme: 'com.example.frontend'),
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: dotenv.env['GITHUB_CLIENT_ID'] ?? "",
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET'] ?? "",
        scopes: ['repo', 'user'],
      );

      AccessTokenResponse? token = await helper.getToken();

      if (token != null && token.accessToken != null) {
        await apiController.credentialAPI.createCredential(
            apiController.user!.uid, "GITHUB", token.accessToken!);
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
              color: services['github']!.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/github.svg',
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Continuer avec Github',
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
