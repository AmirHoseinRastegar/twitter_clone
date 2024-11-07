import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/api_services/tweets_api.dart';
import 'package:twitter_clone/core/tweet_type_enum.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../common/utils.dart';
import '../../auth/controller/auth_controller.dart';


final tweetControllerProvider =
  StateNotifierProvider<TweetController, bool>((ref) {
    final tweetsApi = ref.watch(tweetsApiProvider);
    return TweetController(tweetsApi: tweetsApi,ref: ref);
  });

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetsApi _tweetsApi;

  TweetController({required TweetsApi tweetsApi,required Ref ref})
      : _ref = ref,
        _tweetsApi = tweetsApi,
        super(false);

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
        imageLinks: const[],
        commentIds: const[],
        likes: const[],
        tweetedAt: DateTime.now(),
        id: ID.unique(),
        tweetType: TweetType.text,
        retweetCount: 0);
    final result= await _tweetsApi.shareTweet(tweetModel);
    result.fold((l) => snackBar(context, l.message), (r) => null);
    state = false;
  }

  void _imageContainedTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {}

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
