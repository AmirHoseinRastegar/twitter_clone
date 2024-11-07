import 'package:flutter/material.dart';

enum TweetType {
  text('text'),
  image('image');

  final String type;

  const TweetType(this.type);
}

extension ConvertToEnum on String {
  TweetType toEnum() {
    switch (this) {
      case 'text':
        return TweetType.text;
      case 'image':
        return TweetType.image;
      default:
        return TweetType.text;
    }
  }
}
