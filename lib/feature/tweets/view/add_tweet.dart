import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/utils.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../../../common/common.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/tweet_controller.dart';

class AddTweetView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddTweetView());

  const AddTweetView({super.key});

  @override
  ConsumerState<AddTweetView> createState() => _AddTweetViewState();
}

class _AddTweetViewState extends ConsumerState<AddTweetView> {
  final TextEditingController _tweetTextController = TextEditingController();
  List<File> images = [];

  void pickImage() async {
    images = await pickImages();
    setState(() {});
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: _tweetTextController.text,
          context: context,
      repliedTo: '',
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData = ref.watch(userDetailProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);
    print(currentUserData?.profilePic);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.close)),
          actions: [
            RoundedButton(
              label: 'Tweet',
              onTap: shareTweet,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ),
        body:isLoading || currentUserData == null
            ? const ErrorLandingPage(errorMessage: 'please login first')
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(currentUserData.profilePic),
                          radius: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                         Expanded(
                          child: TextField(
                            controller: _tweetTextController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'What\'s up?',
                              hintStyle: TextStyle(
                                  color: ColorsPallet.greyColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((e) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.file(e));
                        }).toList(),
                        options: CarouselOptions(
                          height: 300,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1, color: ColorsPallet.greyColor.withOpacity(0.5))),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
                child: InkWell(
                  onTap: pickImage,
                  child: SvgPicture.asset(
                    AssetsConstants.galleryIcon,
                    color: ColorsPallet.blueColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
                child: SvgPicture.asset(
                  AssetsConstants.gifIcon,
                  color: ColorsPallet.blueColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
                child: SvgPicture.asset(
                  AssetsConstants.emojiIcon,
                  color: ColorsPallet.blueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
