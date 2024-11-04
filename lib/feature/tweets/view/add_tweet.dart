import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../../../common/common.dart';
import '../../auth/controller/auth_controller.dart';

class AddTweetView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddTweetView());

  const AddTweetView({super.key});

  @override
  ConsumerState<AddTweetView> createState() => _AddTweetViewState();
}

class _AddTweetViewState extends ConsumerState<AddTweetView> {
  @override
  Widget build(BuildContext context) {
    final currentUserData = ref.watch(userDetailProvider).value;
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
              onTap: () {},
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ),
        body: currentUserData == null
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
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Whats up?',
                              hintStyle: TextStyle(
                                  color: ColorsPallet.greyColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
