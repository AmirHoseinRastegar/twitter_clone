import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/feature/auth/widgets/auth_textfield.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import 'login_view.dart';

class SignUpView extends ConsumerStatefulWidget {
  static rout() =>
      MaterialPageRoute(builder: (BuildContext context) => const SignUpView());

  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading= ref.watch(authControllerProvider);
    return isLoading?const LoadingScreen(): SafeArea(
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
                    label: 'Done',
                    onTap: onSignUp,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(
                        color: ColorsPallet.whiteColor, fontSize: 16),
                    children: [
                      TextSpan(
                          text: "Login",
                          style: const TextStyle(
                              color: ColorsPallet.blueColor, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, LoginView.rout());
                            }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
