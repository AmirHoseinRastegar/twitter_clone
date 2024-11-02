import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

import '../constants/appwrite_constants.dart';
import '../models/user_model.dart';

final userApiProvider = Provider((ref) {
  return UserApiImpl(databases: ref.watch(appWriteDatabaseProvider));
});

abstract class UserApi {
  FutureEitherVoid saveUserData({required UserModel userModel});
}

class UserApiImpl implements UserApi {
  final Databases _databases;

  UserApiImpl({required Databases databases}) : _databases = databases;

  @override
  FutureEitherVoid saveUserData({required UserModel userModel}) async {
    try {
      await _databases.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: ID.unique(),
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'Unexpected error occurred', st),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }
}
