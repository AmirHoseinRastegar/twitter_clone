import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/feature/tweets/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweets/widgets/tweets_card.dart';

import '../../../models/tweet_model.dart';

class ReplyScreen extends ConsumerWidget {
  final TweetModel tweetModel;

  static route(TweetModel tweetModel) => MaterialPageRoute(
        builder: (context) => ReplyScreen(tweetModel: tweetModel),
      );

  const ReplyScreen({super.key, required this.tweetModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tweet'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TweetsCard(tweetModel: tweetModel),
              ],
            ),
          ),
        ),
        bottomNavigationBar: TextField(
          ///on submitted is same as controller kinda and does not need textEditingController
          onSubmitted: (value) {
            ref.watch(tweetControllerProvider.notifier).shareTweet(
              images: [],
              text: value,
              context: context,
              repliedTo: tweetModel.id,
            );
          },
          decoration: const InputDecoration(
            hintText: ' your reply',
            contentPadding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}
