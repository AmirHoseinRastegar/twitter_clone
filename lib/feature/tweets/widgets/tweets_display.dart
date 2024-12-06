import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/tweets/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweets/widgets/tweets_card.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';

class TweetsDisplay extends ConsumerStatefulWidget {
  const TweetsDisplay({super.key});

  @override
  ConsumerState<TweetsDisplay> createState() => _TweetsDisplayState();
}

class _TweetsDisplayState extends ConsumerState<TweetsDisplay> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getTweetsFutureProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.create')) {
                      ///0 means latest tweet be shown in top of the list not in bottom of it
                      ///but its not enough for it we need to do some work in tweets api file in list of tweets  function
                      tweets.insert(0, TweetModel.fromJson(data.payload));
                    } else if (data.events.contains(
                      ///update is for updating tweet statuses in realtime like retweets
                        'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.update')) {
                      ///by printing this we realize that tweet id for retweet count updating logic
                      ///comes between 'document.    .update' so we need middle part of it which is the id of the original tweet
                        print('this is data ${data.events[0]}');
                        final startingPoint= data.events[0].lastIndexOf('documents.');
                        final endPoint= data.events[0].lastIndexOf('.update');
                        ///the +10 is for ignoring documents. which is 10 digits long
                        final tweetId= data.events[0].substring(startingPoint+10, endPoint);
                        var tweet= tweets.where((element) =>element.id==tweetId).first;
                        ///first we get index of tweet
                      final  tweetIndex= tweets.indexOf(tweet);
                      ///then we remove it to replace new data
                      tweets.removeWhere((element) => element.id==tweetId);
                      tweet= TweetModel.fromJson(data.payload);
                      tweets.insert(tweetIndex, tweet);

                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweetModel = tweets[index];
                        return TweetsCard(tweetModel: tweetModel);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorMessage(
                      errorMessage: error.toString(),
                    );
                  },

                  ///we put a listview in loading part because app write keeps showing loading part when no data in updated
                  ///or created so we show previous data
                  loading: () => ListView.builder(
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
          loading: () => Container(),
        );
  }
}
