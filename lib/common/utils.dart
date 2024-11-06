import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void snackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final imagePicker = ImagePicker();
  final imagesList = await imagePicker.pickMultiImage();
  if (imagesList.isNotEmpty) {
    for (final image in imagesList) {
      images.add(File(image.path));
    }
  }
  return images;
}
