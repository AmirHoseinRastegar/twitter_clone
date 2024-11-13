import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/tweets/controller/tweet_controller.dart';
import 'package:twitter_clone/feature/tweets/widgets/tweets_card.dart';

class TweetsDisplay extends ConsumerStatefulWidget {
  const TweetsDisplay({super.key});

  @override
  ConsumerState<TweetsDisplay> createState() => _TweetsDisplayState();
}

class _TweetsDisplayState extends ConsumerState<TweetsDisplay> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getTweetsFutureProvider).when(
          data: (data) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10,),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final tweetModel = data[index];
                return TweetsCard(tweetModel: tweetModel);
              },
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
