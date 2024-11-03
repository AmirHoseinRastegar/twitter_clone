import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/api_services/auth_api.dart';
import 'package:twitter_clone/api_services/user_api.dart';
import 'package:twitter_clone/common/utils.dart';
import 'package:twitter_clone/feature/auth/view/login_view.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../home/view/home_screen.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authApi: ref.watch(authApiProvider), userApi: ref.watch(userApiProvider));
});

///since we are using future provider its not needed to use Either in
///auth_api current user session function because future provider has inner error management

final futureSessionProvider = FutureProvider((ref) {
  final authSessionController = ref.watch(authControllerProvider.notifier);
  return authSessionController.currentUser();
});
final userDetailProvider = FutureProvider((ref) {
  final authSessionController = ref.watch(futureSessionProvider).value!.$id;
  final userDetail =
      ref.watch(currentUserAccountProvider(authSessionController));
  return userDetail.value;
});

final currentUserAccountProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid: uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;

  AuthController({required AuthApi authApi, required UserApi userApi})
      : _authApi = authApi,
        _userApi = userApi,
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
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: email.split('@')[0],
          uid: r.$id,
          profilePic: '',
          bannerPic: '',
          bio: '',
          isBlue: true,
          followers: const [],
          following: const [],
        );

        final result2 = await _userApi.saveUserData(userModel: userModel);

        result2.fold((l) => snackBar(context, l.message), (r) {
          snackBar(context, 'account created please login...');
          Navigator.push(context, LoginView.rout());
        });
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
      Navigator.push(context, HomeView.rout());
    });
    state = false;
  }

  Future<UserModel> getUserData({required String uid}) async {
    final result = await _userApi.getUserData(uid: uid);
    final data = UserModel.fromMap(result.data);
    return data;
  }
}
