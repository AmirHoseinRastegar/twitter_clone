import 'package:flutter/cupertino.dart';
import 'package:twitter_clone/core/tweet_type_enum.dart';

@immutable
class TweetModel {
  final String text;

  ///id of the user who created the tweet
  final String uid;
  final String link;
  final List<String> hashtags;
  final List<String> imageLinks;
  final List<String> commentIds;
  final List<String> likes;
  final DateTime tweetedAt;

  ///id of the tweet itself
  final String id;
  final TweetType tweetType;
  final int retweetCount;

  const TweetModel({
    required this.text,
    required this.uid,
    required this.link,
    required this.hashtags,
    required this.imageLinks,
    required this.commentIds,
    required this.likes,
    required this.tweetedAt,
    required this.id,
    required this.tweetType,
    required this.retweetCount,
  });

  TweetModel copyWith({
    String? text,
    String? uid,
    String? link,
    List<String>? hashtags,
    List<String>? imageLinks,
    List<String>? commentIds,
    List<String>? likes,
    DateTime? tweetedAt,
    String? id,
    TweetType? type,
    int? retweetCount,
  }) {
    return TweetModel(
      text: text ?? this.text,
      uid: uid ?? this.uid,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      imageLinks: imageLinks ?? this.imageLinks,
      commentIds: commentIds ?? this.commentIds,
      likes: likes ?? this.likes,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      id: id ?? this.id,
      tweetType: type ?? tweetType,
      retweetCount: retweetCount ?? this.retweetCount,
    );
  }

  factory TweetModel.fromJson(Map<String, dynamic> json) {
    return TweetModel(
      text: json['text'] ,
      uid: json['uid'] ?? '',
      link: json['link'] ?? '',
      hashtags: List<String>.from(json['hashtags']),
      imageLinks: List<String>.from(json['imageLinks']),
      commentIds: List<String>.from(json['commentIds']),
      likes: List<String>.from(json['likes']),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(json['tweetedAt']),
      id: json['\$id'] ?? '',
      tweetType: (json['tweet_type'] as String).toEnum(),
      retweetCount: json['retweetCount']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data.addAll({'text': text});
    data.addAll({'uid': uid});
    data.addAll({'link': link});
    data.addAll({'hashtags': hashtags});
    data.addAll({'imageLinks': imageLinks});
    data.addAll({'commentIds': commentIds});
    data.addAll({'likes': likes});
    data.addAll({'tweetedAt': tweetedAt.millisecondsSinceEpoch});
    data.addAll({'tweet_type': tweetType.type});
    data.addAll({'retweetCount': retweetCount});
    return data;
  }
}
