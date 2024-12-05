import 'package:flutter/material.dart';

import '../../../theme/colors_pallet.dart';

class FollowWidget extends StatelessWidget {
  final int count;
  final String text;

  const FollowWidget({super.key, required this.count, required this.text});

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return Row(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: ColorsPallet.whiteColor,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: ColorsPallet.greyColor,
          ),
        ),
      ],
    );
  }
}
