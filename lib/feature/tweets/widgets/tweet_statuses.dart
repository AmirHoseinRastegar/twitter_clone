import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

class TweetStatuses extends StatelessWidget {
  final String pathName;
  final VoidCallback onTap;
  final String text;

  const TweetStatuses(
      {super.key,
      required this.pathName,
      required this.onTap,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathName,
            color: ColorsPallet.greyColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
