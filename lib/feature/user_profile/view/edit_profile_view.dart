import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );

  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userDetailProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditProfile'),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Save',
                style: TextStyle(color: ColorsPallet.blueColor),
              ))
        ],
      ),
      body: currentUser == null
          ? Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: currentUser.bannerPic.isEmpty
                            ? Container(
                                color: ColorsPallet.blueColor,
                              )
                            : Image.network(currentUser.bannerPic),
                      ),
                      Positioned(
                          bottom: 7,
                          left: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(currentUser.profilePic),
                          ))
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio',
                    contentPadding: EdgeInsets.all(15),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
    );
  }
}
