import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/feature/user_profile/view/user_profile_view.dart';

import '../../../models/user_model.dart';
import '../../../theme/colors_pallet.dart';

class SearchTile extends ConsumerWidget {
  final UserModel userModel;

  const SearchTile(this.userModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () => Navigator.push(context, UserProfileView.route(userModel)),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(userModel.profilePic),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          userModel.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: ColorsPallet.whiteColor),
          ),
        ],
      ),
    );
  }
}
