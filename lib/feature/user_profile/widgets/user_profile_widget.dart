import 'package:flutter/material.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

class UserProfileWidget extends StatelessWidget {
  final UserModel userModel;

  const UserProfileWidget({required this.userModel, super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
                ],
              ),
            ),
          ];
        },
        body: Container());
  }
}
