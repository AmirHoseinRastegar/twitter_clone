import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

/*
when we want to sign up or get user account we use "Account" of app write
when we want to get use related data we use "User" of app write

*/
abstract class AuthAPi {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });
}

class AuthAPiImpl implements AuthAPi {
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
}
