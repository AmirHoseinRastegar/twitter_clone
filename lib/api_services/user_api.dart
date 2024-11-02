
import 'package:twitter_clone/core/core.dart';

import '../models/user_model.dart';

abstract class UserApi{

FutureEitherVoid saveUserData({required UserModel userModel});

}

class UserApiImpl implements UserApi{
  @override
  FutureEitherVoid saveUserData({required UserModel userModel}) {
    // TODO: implement saveUserData
    throw UnimplementedError();
  }

}