import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../../../common/error.dart';
import '../../../common/loadings.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetsCard extends ConsumerWidget {
  final TweetModel tweetModel;

  const TweetsCard({super.key, required this.tweetModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserAccountProvider(tweetModel.uid)).when(
          data: (data) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(data.profilePic),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 7),
                              child: Text(
                                data.name,
                                style: const TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '@${data.name} . ${timeago.format(tweetModel.tweetedAt, locale: 'en_short')}',
                              style: const TextStyle(
                                  fontSize: 17, color: ColorsPallet.greyColor),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            );
          },
          error: (error, stackTrace) {
            return ErrorMessage(
              errorMessage: error.toString(),
            );
          },
          loading: () => Loader(),
        );
  }
}
