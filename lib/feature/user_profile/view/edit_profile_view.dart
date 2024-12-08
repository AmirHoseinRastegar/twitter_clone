import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/auth/controller/auth_controller.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../controller/user_porfle_controller.dart';

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
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        profileFile = banner;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userDetailProvider).value;
    final isLoading = ref.watch(useProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditProfile'),
        actions: [
          TextButton(
              onPressed: () {
                ref
                    .read(useProfileControllerProvider.notifier)
                    .updateUserProfileData(
                        userModel: currentUser!,
                        context: context,
                        profileFile: profileFile,
                        bannerFile: bannerFile);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: ColorsPallet.blueColor),
              ))
        ],
      ),
      body: isLoading || currentUser == null
          ? Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: bannerFile != null
                              ? Image.file(
                                  bannerFile!,
                                  fit: BoxFit.fitWidth,
                                )
                              : currentUser.bannerPic.isEmpty
                                  ? Container(
                                      color: ColorsPallet.blueColor,
                                    )
                                  : Image.network(
                                      currentUser.bannerPic,
                                      fit: BoxFit.fitWidth,
                                    ),
                        ),
                      ),
                      Positioned(
                          bottom: 7,
                          left: 10,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileFile != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(profileFile!),
                                    radius: 40,
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(currentUser.profilePic),
                                  ),
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
