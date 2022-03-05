import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/login/email_login.dart';
import 'package:frontend/components/login/login_with_button.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'dart:convert';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    SvgPicture.asset(
                      'assets/logo.svg',
                      semanticsLabel: 'IFTTT Like Logo',
                      height: kIsWeb ? 47 : 43,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Est-ce que t\'as déjà léché ?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(child: Lottie.asset('assets/loti/login.json')),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(45),
                splashColor: Colors.black.withOpacity(0.2),
                highlightColor: Colors.transparent,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Wrap(
                      children: const [
                        _LoginOptions(),
                      ],
                    ),
                    isScrollControlled: true,
                    enableDrag: !kIsWeb,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    barrierColor: kIsWeb ? Colors.transparent : null,
                  );
                },
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _LoginOptions extends StatelessWidget {
  const _LoginOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (kIsWeb)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: const Text(
                'Explorer',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          if (!kIsWeb)
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 30),
              width: 23,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black,
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginWithButton(
                    pathToIcon: 'assets/icons/github.svg',
                    text: 'Continuer avec Github',
                    onTap: () async {
                      try {
                        OAuth2Helper helper = OAuth2Helper(
                          GitHubOAuth2Client(
                              redirectUri: 'com.example.frontend://home',
                              customUriScheme: 'com.example.frontend'),
                          grantType: OAuth2Helper.AUTHORIZATION_CODE,
                          clientId: '652a1436625a54db39b6',
                          clientSecret:
                              'f7fca66b14d21c2ecd1de6a1b502e9905bea484c',
                          scopes: ['repo', 'user'],
                        );

                        var resp = await helper
                            .get('https://api.github.com/user/emails');
                        AccessTokenResponse? token =
                            await helper.getTokenFromStorage();
                        final body = json.decode(resp.body);
                        String email = body[0]['email'];
                        for (var x in body) {
                          email = x['email'];
                          if (x['primary'] == true) {
                            break;
                          }
                        }

                        await apiController.userAPI
                            .oauthSignin(token?.accessToken, email, "GITHUB");

                        apiController.user = await apiController.userAPI.me();

                        Get.offAllNamed('/home');
                      } catch (e) {
                        Get.snackbar(
                          'Erreur',
                          e.toString().split('\n')[0],
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }),
                const SizedBox(height: 15),
                LoginWithButton(
                    pathToIcon: 'assets/icons/google.svg',
                    text: 'Continuer avec Google',
                    onTap: () async {
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

                        var resp = await helper.get(
                            'https://people.googleapis.com/v1/people/me?personFields=emailAddresses');
                        AccessTokenResponse? token =
                            await helper.getTokenFromStorage();
                        final body = json.decode(resp.body);
                        String email = body['emailAddresses'][0]['value'];

                        await apiController.userAPI
                            .oauthSignin(token?.accessToken, email, "GOOGLE");

                        apiController.user = await apiController.userAPI.me();

                        Get.offAllNamed('/home');
                      } catch (e) {
                        Get.snackbar(
                          'Erreur',
                          e.toString().split('\n')[0],
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }),
                const SizedBox(height: 15),
                LoginWithButton(
                  pathToIcon: 'assets/icons/email.svg',
                  text: 'Continuer avec votre e-mail',
                  onTap: () => Get.to(
                    const EmailLogin(),
                    transition: kIsWeb
                        ? Transition.noTransition
                        : Transition.rightToLeft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
