import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/feature/tweets/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweets/widgets/tweets_card.dart';

import '../../../common/error.dart';
import '../../../constants/appwrite_constants.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TweetsCard(tweetModel: tweetModel),
              ref.watch(getRepliedTweetsProvider(tweetModel)).when(
                  data: (tweets) {
                    return ref.watch(getLatestTweetProvider).when(
                          data: (data) {
                            final latestTweets =
                                TweetModel.fromJson(data.payload);
                            bool isAlreadyTweeted = false;
                            for (final tweetLoop in tweets) {
                              if (tweetLoop.id == latestTweets.id) {
                                isAlreadyTweeted = true;
                                break;
                              }
                            }
                            if (latestTweets.repliedTo == tweetModel.id &&
                                !isAlreadyTweeted) {
                              if (data.events.contains(
                                  'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.create')) {
                                tweets.insert(
                                    0, TweetModel.fromJson(data.payload));
                              } else if (data.events.contains(
                                  'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.update')) {
                                final startPoint =
                                    data.events[0].lastIndexOf('documents.');
                                final endPoint =
                                    data.events[0].lastIndexOf('.update');
                                final tweetId = data.events[0]
                                    .substring(startPoint + 10, endPoint);
                                var tweet = tweets
                                    .where((element) => element.id == tweetId)
                                    .first;
                                final tweetIndex = tweets.indexOf(tweet);
                                tweets.removeWhere(
                                    (element) => element.id == tweetId);
                                tweet = TweetModel.fromJson(data.payload);
                                tweets.insert(tweetIndex, tweet);
                              }
                            }

                            return Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                itemCount: tweets.length,
                                itemBuilder: (context, index) {
                                  final tweetModel = tweets[index];
                                  return TweetsCard(tweetModel: tweetModel);
                                },
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorMessage(
                              errorMessage: error.toString(),
                            );
                          },
                          loading: () => Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              itemCount: tweets.length,
                              itemBuilder: (context, index) {
                                final tweetModel = tweets[index];
                                return TweetsCard(tweetModel: tweetModel);
                              },
                            ),
                          ),
                        );
                  },
                  error: (error, stackTrace) {
                    return ErrorMessage(
                      errorMessage: error.toString(),
                    );
                  },
                  loading: () => Container())
            ],
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
