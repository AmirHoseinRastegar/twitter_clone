import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user_model.dart';

class ExploreController extends StateNotifier<bool> {
  ExploreController() : super(false);
  Future<List<UserModel>> searchUser(String name) async{
    return [];
  }
}
