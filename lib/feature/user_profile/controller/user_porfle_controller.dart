import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../api_services/tweets_api.dart';

final useProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(tweetApi: ref.watch(tweetsApiProvider));
});

final getUserTweetsProfileProvider = FutureProvider.family((ref, String uid) {
  final userTweets = ref.watch(useProfileControllerProvider.notifier);
  return userTweets.getUserProfileTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetsApi _tweetApi;

  UserProfileController({required TweetsApi tweetApi})
      : _tweetApi = tweetApi,
        super(false);

  Future<List<TweetModel>> getUserProfileTweets(String uid) async {
    final result = await _tweetApi.getUserProfileTweets(uid);
    return result.map((e) => TweetModel.fromJson(e.data)).toList();
  }
}
