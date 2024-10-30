import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/feature/auth/view/sign_up_view.dart';
import 'package:twitter_clone/feature/auth/widgets/auth_textfield.dart';

import '../../../common/common.dart';
import '../../../theme/theme.dart';

class LoginView extends StatefulWidget {
  static rout() =>
      MaterialPageRoute(builder: (BuildContext context) => const LoginView());
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: UIConstants.appBar(),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                AuthTextField(hintText: 'email', controller: emailController),
                const SizedBox(
                  height: 20,
                ),
                AuthTextField(
                    hintText: 'password', controller: passwordController),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedButton(
                    label: 'Login',
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                    text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                            color: ColorsPallet.whiteColor, fontSize: 16),
                        children: [
                      TextSpan(
                          text: "Sign up",
                          style: const TextStyle(color: ColorsPallet.blueColor,fontSize: 16),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.push(context, SignUpView.rout());
                          })
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}