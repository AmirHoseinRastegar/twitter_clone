import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/feature/user_profile/controller/user_porfle_controller.dart';
import 'package:twitter_clone/feature/user_profile/widgets/follow_widget.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

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
                          onPressed: () {},
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
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final tweet = data[index];
                        return Column();
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorMessage(errorMessage: error.toString()),
                  loading: () => Loader(),
                ));
  }
}
