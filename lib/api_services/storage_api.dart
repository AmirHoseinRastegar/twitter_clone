import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';

import '../core/providers.dart';

final storageProvider = Provider((ref) {
  final stProvider = ref.watch(appStorageProvider);
  return StorageApi(storage: stProvider);
});

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
      ///by using image link getter func we convert id that comes from user to
      ///a proper link to storage of app write storage to get stored properly
      imageFiles.add(AppWriteConstants.imageLinkGetter(uploadedImage.$id));
    }
    return imageFiles;
  }
}
