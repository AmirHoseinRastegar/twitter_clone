import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

/*
when we want to sign up or get user account we use "Account" of app write
when we want to get use related data we use "User" of app write

*/

final authApiProvider = Provider((ref) {
  return AuthAPiImpl(
    account: ref.watch(appWriteAccountProvider),
  );
});

abstract class AuthApi {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });
}

class AuthAPiImpl implements AuthApi {
  final Account _account;

  AuthAPiImpl({required Account account}) : _account = account;

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final acc = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(acc);
    } on AppwriteException catch (e, str) {
      return left(Failure(e.message ?? 'Something went wrong', str));
    } catch (e, str) {
      return left(Failure(e.toString(), str));
    }
  }

  @override
  FutureEither<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _account.createEmailPasswordSession(
          email: email, password: password);
      return right(res);
    } on AppwriteException catch (e, str) {
      return left(Failure(e.message ?? 'Unknown error Occurred', str));
    } catch (e, str) {
      return left(Failure(e.toString(), str));
    }
  }
}
