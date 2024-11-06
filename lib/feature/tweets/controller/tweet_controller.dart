import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TweetController extends StateNotifier<bool> {
  TweetController() : super(false);

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

  void _textOnlyTweet({
    required String text,
    required BuildContext context,
  }) {}

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
    List<String> isHashTag =[];
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
