import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/api_services/storage_api.dart';
import 'package:twitter_clone/api_services/tweets_api.dart';
import 'package:twitter_clone/core/tweet_type_enum.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../common/utils.dart';
import '../../auth/controller/auth_controller.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  final tweetsApi = ref.watch(tweetsApiProvider);
  final storageApi = ref.watch(storageProvider);
  return TweetController(
      tweetsApi: tweetsApi, ref: ref, storageApi: storageApi);
});

final getTweetsFutureProvider = FutureProvider.autoDispose((ref) {
  final tweetsController = ref.watch(tweetControllerProvider.notifier);
  return tweetsController.getTweets();
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetsApiProvider);
  return tweetAPI.getLatestTweets();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetsApi _tweetsApi;
  final StorageApi _storageApi;

  TweetController(
      {required TweetsApi tweetsApi,
      required Ref ref,
      required StorageApi storageApi})
      : _ref = ref,
        _storageApi = storageApi,
        _tweetsApi = tweetsApi,
        super(false);

  Future<List<TweetModel>> getTweets() async {
    final tweets = await _tweetsApi.getTweets();
    return tweets
        .map((tweetElement) => TweetModel.fromJson(tweetElement.data))
        .toList();
  }

  Future<void> likeTweet(TweetModel tweetModel, UserModel userModel) async {
    List<String> likes = tweetModel.likes;
    if (likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      likes.add(userModel.uid);
    }
    tweetModel = tweetModel.copyWith(likes: likes);
    final res = await _tweetsApi.likeTweet(tweetModel);
    res.fold((l) => null, (r) => null);
  }

  void retweetsCount(
    TweetModel tweetModel,
    UserModel user,
    BuildContext context,
  ) async {
    tweetModel = tweetModel.copyWith(
      retweetedBy: user.name,

      ///we make like and comments empty because a retweeted tweet will not have any likes or comments
      ///by itself
      likes: [],
      commentIds: [],
      retweetCount: tweetModel.retweetCount + 1,
    );

    final res = await _tweetsApi.retweetsCount(tweetModel);
    res.fold(
      (l) => snackBar(context, l.message),
      (r) async {
        tweetModel = tweetModel.copyWith(
          ///since we making a new tweet by retweeting a tweet it needs a new unique id
          ///and retweet count should be 0 in that case
          id: ID.unique(),
          retweetCount: 0,
          tweetedAt: DateTime.now(),

        );
        final res2 = await _tweetsApi.shareTweet(tweetModel);
        res2.fold((l) => snackBar(context, l.message),
            (r) => snackBar(context, 'Retweeted'));
      },
    );
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (images.isNotEmpty) {
      _imageContainedTweet(images: images, text: text, context: context);
    } else {
      _textOnlyTweet(text: text, context: context);
    }
  }

  Future<void> _textOnlyTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;

    String link = _getLinkText(text);
    final hashtags = _getHashTagText(text);
    final userId = _ref.watch(userDetailProvider).value!;
    TweetModel tweetModel = TweetModel(
        text: text,
        uid: userId.uid,
        link: link,
        hashtags: hashtags,
        imageLinks: const [],
        commentIds: const [],
        likes: const [],
        tweetedAt: DateTime.now(),
        id: ID.unique(),
        tweetType: TweetType.text,
        retweetCount: 0,
        retweetedBy: '');
    final result = await _tweetsApi.shareTweet(tweetModel);
    result.fold((l) => snackBar(context, l.message), (r) => null);
    state = false;
  }

  void _imageContainedTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;

    String link = _getLinkText(text);
    final hashtags = _getHashTagText(text);
    final userId = _ref.watch(userDetailProvider).value!;
    final imageLinks = await _storageApi.uploadImages(images);
    TweetModel tweetModel = TweetModel(
        text: text,
        uid: userId.uid,
        link: link,
        hashtags: hashtags,
        imageLinks: imageLinks,
        commentIds: const [],
        likes: const [],
        tweetedAt: DateTime.now(),
        id: ID.unique(),
        tweetType: TweetType.image,
        retweetCount: 0,
        retweetedBy: '');
    final result = await _tweetsApi.shareTweet(tweetModel);
    result.fold((l) => snackBar(context, l.message), (r) => null);
    state = false;
  }

  String _getLinkText(String words) {
    String isLink = '';
    List<String> wordId = words.split(' ');
    if (wordId.isNotEmpty) {
      for (String word in wordId) {
        if (word.startsWith('https://') || word.startsWith('www.')) {
          isLink = word;
        }
      }
    }
    return isLink;
  }

  List<String> _getHashTagText(String words) {
    List<String> isHashTag = [];
    List<String> wordId = words.split(' ');
    if (wordId.isNotEmpty) {
      for (String word in wordId) {
        if (word.startsWith('#')) {
          isHashTag.add(word);
        }
      }
    }
    return isHashTag;
  }
}
