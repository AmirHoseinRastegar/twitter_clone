import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/feature/user_profile/controller/user_porfle_controller.dart';
import 'package:twitter_clone/feature/user_profile/widgets/follow_widget.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';
import '../../tweets/controller/tweet_controller.dart';
import '../../tweets/widgets/tweets_card.dart';
import '../view/edit_profile_view.dart';

class UserProfileWidget extends ConsumerWidget {
  final UserModel userModel;

  const UserProfileWidget({required this.userModel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userDetailProvider).value;
    return currentUser == null
        ? Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: userModel.bannerPic.isEmpty
                            ? Container(
                                color: ColorsPallet.blueColor,
                              )
                            : Image.network(userModel.bannerPic),
                      ),
                      Positioned(
                          bottom: 4,
                          left: 6,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(userModel.profilePic),
                          )),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                    color: ColorsPallet.whiteColor)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                          ),
                          onPressed: () {
                           if(currentUser.uid == userModel.uid){
                             Navigator.push(context, EditProfileView.route());
                           }
                          },
                          child: Text(
                            currentUser.uid == userModel.uid
                                ? 'Edit Profile'
                                : 'Follow',
                            style: const TextStyle(
                              color: ColorsPallet.whiteColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          userModel.name,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Text('@${userModel.name}'),
                        Text(
                          userModel.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FollowWidget(
                              count: userModel.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FollowWidget(
                              count: userModel.followers.length,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Divider(
                          color: ColorsPallet.whiteColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserTweetsProfileProvider(userModel.uid)).when(
                  data: (tweets) {
                    print(tweets);
                    return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          // final latestTweets =
                          //     TweetModel.fromJson(data.payload);
                          // bool isAlreadyTweeted = false;
                          // for (final tweetLoop in tweets) {
                          //   if (tweetLoop.id == latestTweets.id) {
                          //     isAlreadyTweeted = true;
                          //     break;
                          //   }
                          // }
                          // if (!isAlreadyTweeted) {
                            if (data.events.contains(
                                'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.create')) {
                              tweets.insert(
                                  0, TweetModel.fromJson(data.payload));
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
                              left: 15,

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
                        loading: () => ListView.builder(
                          padding: const EdgeInsets.only(
                           left: 15
                          ),
                          itemCount: tweets.length,
                          itemBuilder: (context, index) {
                            final tweetModel = tweets[index];
                            return TweetsCard(tweetModel: tweetModel);
                          },
                        ));
                  },
                  error: (error, stackTrace) =>
                      ErrorMessage(errorMessage: error.toString()),
                  loading: () => Loader(),
                ));
  }
}
