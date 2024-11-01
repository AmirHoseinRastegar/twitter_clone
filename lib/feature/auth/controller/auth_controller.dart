import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/api_services/auth_api.dart';
import 'package:twitter_clone/common/utils.dart';
import 'package:twitter_clone/feature/auth/view/login_view.dart';

import '../../home/view/home_screen.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(authApi: ref.watch(authApiProvider));
});
///since we are using future provider its not needed to use Either in
///auth_api current user session function because future provider has inner error management

final futureSessionProvider = FutureProvider((ref) {
  final authSessionController = ref.watch(authControllerProvider.notifier);
  return authSessionController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;

  AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  /// isLoading state class

  void signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final result = await _authApi.signUp(
      email: email,
      password: password,
    );
    result.fold(
      (l) => snackBar(context, l.message),
      (r) {
        snackBar(context, 'account created please login...');
        Navigator.push(context, LoginView.rout());
        print(r.email);
      },
    );
    state = false;
  }

  Future<User?> currentUser() => _authApi.currentUserSession();

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authApi.login(email: email, password: password);
    result.fold((l) {
      snackBar(context, l.message);
    }, (r) {
      snackBar(context, 'logged in');
      Navigator.push(context, HomeScreen.rout());
    });
    state = false;
  }
}
