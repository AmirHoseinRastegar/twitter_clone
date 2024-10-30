import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller ;
  final String hintText;

  const AuthTextField({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: ColorsPallet.blueColor, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: ColorsPallet.greyColor,),
        ),
      ),
    );
  }
}
