import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../../tweets/view/add_tweet.dart';

class HomeView extends StatefulWidget {
  static rout() => MaterialPageRoute(builder: (context) => const HomeView());

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  void onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void onAddTweet() {
    Navigator.push(context, AddTweetView.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,),
        child: IndexedStack(
          index: _page,
          children: UIConstants.bottomItems,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTweet,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add),
      ),
      appBar:_page==0? UIConstants.appBar():null,
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChanged,
        backgroundColor: ColorsPallet.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: _page == 0
                ? SvgPicture.asset(
                    AssetsConstants.homeFilledIcon,
                    color: ColorsPallet.whiteColor,
                  )
                : SvgPicture.asset(
                    AssetsConstants.homeOutlinedIcon,
                    color: ColorsPallet.whiteColor,
                  ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: ColorsPallet.whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: _page == 2
                ? SvgPicture.asset(
                    AssetsConstants.notifFilledIcon,
                    color: ColorsPallet.whiteColor,
                  )
                : SvgPicture.asset(
                    AssetsConstants.notifOutlinedIcon,
                    color: ColorsPallet.whiteColor,
                  ),
          ),
        ],
      ),
    );
  }
}
