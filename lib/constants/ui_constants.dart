import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

import '../feature/tweets/widgets/tweets_display.dart';
import 'constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: ColorsPallet.blueColor,
        width: 35,
      ),
    );
  }

  static List<Widget> bottomItems = <Widget>[
    const TweetsDisplay(),
    const Text('search'),
    const Text('notification'),
  ];
}
