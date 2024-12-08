import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/api_services/storage_api.dart';
import 'package:twitter_clone/api_services/user_api.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../api_services/tweets_api.dart';
import '../../../models/user_model.dart';

final useProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetApi: ref.watch(tweetsApiProvider),
    storageApi: ref.watch(storageProvider),
    userApi: ref.watch(userApiProvider),
  );
});

final getUserTweetsProfileProvider = FutureProvider.family((ref, String uid) {
  final userTweets = ref.watch(useProfileControllerProvider.notifier);
  return userTweets.getUserProfileTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetsApi _tweetApi;
  final StorageApi _storageApi;
  final UserApi _userApi;

  UserProfileController({
    required UserApi userApi,
    required TweetsApi tweetApi,
    required StorageApi storageApi,
  })  : _tweetApi = tweetApi,
        _storageApi = storageApi,
        _userApi = userApi,
        super(false);

  Future<List<TweetModel>> getUserProfileTweets(String uid) async {
    final result = await _tweetApi.getUserProfileTweets(uid);
    return result.map((e) => TweetModel.fromJson(e.data)).toList();
  }

  void updateUserProfileData({
    required UserModel userModel,
    required BuildContext context,
    File? bannerFile,
    File? profileFile,
  }) async {
    state=true;
    if (bannerFile != null) {
      final banner = await _storageApi.uploadImages([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: banner[0],
      );
    }
    if (profileFile != null) {
      final profile = await _storageApi.uploadImages([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profile[0],
      );
    }
    final result = await _userApi.updateUserData( userModel);
    state=false;
    result.fold(
      (l) => snackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }
}
