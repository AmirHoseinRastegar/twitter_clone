import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api_services/user_api.dart';
import '../../../models/user_model.dart';

final exploreController = StateNotifierProvider((ref) {
  return ExploreController(userApi: ref.watch(userApiProvider));
});
final searchUsersProvider = FutureProvider.family((ref, String name) {
  final user = ref.watch(exploreController.notifier);
  return user.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserApi _userApi;

  ExploreController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userApi.searchUserByName(name: name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
