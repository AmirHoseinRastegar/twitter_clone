import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

class HashtagsAndLinks extends StatelessWidget {
  final String text;

  const HashtagsAndLinks({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpansList = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpansList.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
                color: ColorsPallet.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        );
      } else if (element.startsWith('www.') ||
          element.startsWith('https://') ||
          element.startsWith('http://')) {
        textSpansList.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
                color: ColorsPallet.blueColor,
                fontSize: 18),
          ),
        );
      } else {
        textSpansList.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
        );
      }
    });

    return RichText(
      text: TextSpan(children: textSpansList),
    );
  }
}
