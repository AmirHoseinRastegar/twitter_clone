import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';

class StorageApi {
  final Storage _storage;

  StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageFiles = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppWriteConstants.tweetBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageFiles.add(uploadedImage.$id);
    }
    return imageFiles;
  }
}
