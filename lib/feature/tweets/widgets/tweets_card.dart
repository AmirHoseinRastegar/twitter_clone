import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/feature/tweets/widgets/hashtags_links.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../../../common/error.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/appwrite_constants.dart';
import '../../../core/tweet_type_enum.dart';
import 'carousel_slider.dart';

class TweetsCard extends ConsumerWidget {
  final TweetModel tweetModel;

  const TweetsCard({super.key, required this.tweetModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(tweetModel.imageLinks);
    print(AppWriteConstants.endpoint);
    return ref.watch(currentUserAccountProvider(tweetModel.uid)).when(
          data: (data) {
            return Container(
              padding:  const EdgeInsets.only(top: 12,bottom: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: CircleAvatar(
                          onBackgroundImageError: (exception, stackTrace) =>
                              const Center(
                            child: Icon(Icons.error),
                          ),
                          radius: 35,
                          backgroundImage: NetworkImage(
                            data.profilePic,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 7),
                                  child: Text(
                                    data.name,
                                    style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  '@${data.name} . ${timeago.format(tweetModel.tweetedAt, locale: 'en_short')}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: ColorsPallet.greyColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            HashtagsAndLinks(text: tweetModel.text),
                            if(tweetModel.tweetType == TweetType.image)
                              CrouselTweetImages(imageLinks: tweetModel.imageLinks),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 0.2, thickness: 0.3, color: ColorsPallet.greyColor),
                ],
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
