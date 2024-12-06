import 'dart:ui';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:svg_flutter/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/feature/tweets/widgets/hashtags_links.dart';
import 'package:twitter_clone/feature/tweets/widgets/tweet_statuses.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';
import 'package:twitter_clone/theme/theme.dart';

import '../../../common/error.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/tweet_type_enum.dart';
import '../controller/tweet_controller.dart';
import '../view/reply_screen.dart';
import 'carousel_slider.dart';

class TweetsCard extends ConsumerWidget {
  final TweetModel tweetModel;

  const TweetsCard({super.key, required this.tweetModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///this current use is the user who is currently logged in in the app so
    ///for the tweet to be liked it should be liked by the current user or other actions like retweeting etc
    final currentUser = ref.watch(userDetailProvider).value;
    return ref.watch(currentUserAccountProvider(tweetModel.uid)).when(
          data: (data) {
            return currentUser == null
                ? Container()
                : GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      ReplyScreen.route(tweetModel),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tweetModel.retweetedBy.isNotEmpty)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsConstants.retweetIcon,
                                  color: ColorsPallet.greyColor,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${tweetModel.retweetedBy} retweeted',
                                  style: const TextStyle(
                                    color: ColorsPallet.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 12, top: 0, left: 0),
                                child: CircleAvatar(
                                  onBackgroundImageError:
                                      (exception, stackTrace) => const Center(
                                    child: Icon(Icons.error),
                                  ),
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    data.profilePic,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 7),
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
                                    if (tweetModel.repliedTo.isNotEmpty)
                                      ref
                                          .watch(
                                        getTweetByIdProvider(tweetModel.repliedTo),
                                      )
                                          .when(
                                          data: (data) {
                                            final replyingToUserName = ref.watch(
                                                currentUserAccountProvider(data.uid)).value;
                                            return RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                      ///should use ? mark not ! because it may be null
                                                      '@${replyingToUserName?.name} ',
                                                      style: const TextStyle(
                                                        color: ColorsPallet.blueColor,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  text: 'Replying to  ',
                                                  style: const TextStyle(
                                                    color: ColorsPallet.greyColor,
                                                    fontSize: 15,
                                                  )),
                                            );
                                          },
                                          error: (error, stackTrace) => ErrorMessage(
                                            errorMessage: error.toString(),
                                          ),
                                          loading: () => Container()),
                                    const SizedBox(height: 3,),
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: HashtagsAndLinks(
                                            text: tweetModel.text)),
                                    if (tweetModel.tweetType == TweetType.image)
                                      CrouselTweetImages(
                                          imageLinks: tweetModel.imageLinks),
                                    if (tweetModel.likes.isNotEmpty) ...[
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // AnyLinkPreview(
                                      //     link: 'https://${tweetModel.link}'),
                                    ],
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TweetStatuses(
                                              pathName:
                                                  AssetsConstants.viewsIcon,
                                              onTap: () {},
                                              text: (tweetModel.likes.length +
                                                      tweetModel
                                                          .commentIds.length +
                                                      tweetModel.retweetCount)
                                                  .toString()),
                                          TweetStatuses(
                                              pathName:
                                                  AssetsConstants.commentIcon,
                                              onTap: () {},
                                              text: tweetModel.commentIds.length
                                                  .toString()),
                                          LikeButton(
                                            size: 23,
                                            likeBuilder: (isLiked) {
                                              return isLiked
                                                  ? SvgPicture.asset(
                                                      AssetsConstants
                                                          .likeFilledIcon,
                                                      color:
                                                          ColorsPallet.redColor,
                                                    )
                                                  : SvgPicture.asset(
                                                      AssetsConstants
                                                          .likeOutlinedIcon,
                                                      color: ColorsPallet
                                                          .greyColor,
                                                    );
                                            },
                                            isLiked: tweetModel.likes
                                                .contains(currentUser.uid),
                                            likeCount: tweetModel.likes.length,
                                            countBuilder:
                                                (count, isLiked, text) {
                                              return Text(
                                                text,
                                                style: TextStyle(
                                                    color: isLiked
                                                        ? ColorsPallet.redColor
                                                        : ColorsPallet
                                                            .greyColor,
                                                    fontSize: 16),
                                              );
                                            },
                                            onTap: (isLiked) async {
                                              ref
                                                  .watch(tweetControllerProvider
                                                      .notifier)
                                                  .likeTweet(
                                                      tweetModel, currentUser);
                                              return !isLiked;
                                            },
                                          ),
                                          TweetStatuses(
                                            pathName:
                                                AssetsConstants.retweetIcon,
                                            onTap: () {
                                              ref
                                                  .read(tweetControllerProvider
                                                      .notifier)
                                                  .retweetsCount(
                                                    tweetModel,
                                                    currentUser,
                                                    context,
                                                  );
                                            },
                                            text: tweetModel.retweetCount
                                                .toString(),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.share_outlined,
                                              size: 27,
                                              color: ColorsPallet.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                              height: 0.2,
                              thickness: 0.3,
                              color: ColorsPallet.greyColor),
                        ],
                      ),
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
