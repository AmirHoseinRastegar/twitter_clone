import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';
import 'package:twitter_clone/theme/theme.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RoundedButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backgroundColor = ColorsPallet.whiteColor,
    this.textColor = ColorsPallet.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        label: Text(
          label,
          style: TextStyle(color: textColor,fontSize: 15),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
