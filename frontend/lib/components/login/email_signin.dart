import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/login/email_login.dart';
import 'package:frontend/components/login/web_login.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:get/get.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kIsWeb
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: TextButton(
                child: SvgPicture.asset(
                  'assets/icons/left-arrow.svg',
                  semanticsLabel: 'personna icon',
                  alignment: Alignment.centerLeft,
                  color: Colors.black,
                  width: 20,
                ),
                onPressed: () => Get.back(),
              ),
            ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enregistrez-vous !',
                style: TextStyle(
                  fontSize: kIsWeb ? 36 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                autofocus: true,
                controller: _mailController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                  ),
                  hintText: 'Adresse e-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                  ),
                  hintText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () =>
                    Get.off(kIsWeb ? const WebLogin() : const EmailLogin()),
                child: Text(
                  'Déjà de compte ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: !_isLoading
                      ? () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await apiController.userAPI.register(
                              _mailController.text,
                              _passwordController.text,
                            );
                            await apiController.userAPI.login(
                              _mailController.text,
                              _passwordController.text,
                            );
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
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(45),
                  splashColor: Colors.black.withOpacity(0.2),
                  highlightColor: Colors.transparent,
                  child: SizedBox(
                    width: double.infinity,
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
                      child: Align(
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              )
                            : const Text(
                                'Continuer',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kIsWeb ? 0 : 60),
            ],
          ),
        ),
      ),
    );
  }
}
