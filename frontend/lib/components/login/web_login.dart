import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/components/login/email_login.dart';
import 'package:frontend/components/login/login_with_button.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:get/get.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class WebLogin extends StatelessWidget {
  const WebLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SvgPicture.asset(
              'assets/logo.svg',
              semanticsLabel: 'IFTTT Like Logo',
              alignment: Alignment.centerLeft,
              height: 47,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 420,
                child: Transform.translate(
                  offset: const Offset(0, -100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 360,
                        child: EmailLogin(),
                      ),
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
                              await apiController.userAPI.oauthSignin(
                                  token?.accessToken, email, "GITHUB");

                              apiController.user =
                                  await apiController.userAPI.me();

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

                            await apiController.userAPI.oauthSignin(
                                token?.accessToken, email, "GOOGLE");

                            apiController.user =
                                await apiController.userAPI.me();

                            Get.offAllNamed('/home');
                          } catch (e) {
                            Get.snackbar(
                              'Erreur',
                              e.toString().split('\n')[0],
                              backgroundColor: Colors.red,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
