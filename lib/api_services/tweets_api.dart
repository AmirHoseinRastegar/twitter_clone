import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/tweet_model.dart';


final tweetsApiProvider = Provider((ref) {
  final databases = ref.watch(appWriteDatabaseProvider);
  return TweetsApiImpl(databases: databases);
});


abstract class TweetsApi {
  FutureEither<Document> shareTweet(TweetModel tweetModel);
}

class TweetsApiImpl implements TweetsApi {
  final Databases _databases;

  TweetsApiImpl({required Databases databases}) : _databases = databases;

  @override
  FutureEither<Document> shareTweet(TweetModel tweetModel) async {
    try {
      final res = await _databases.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetCollectionId,
        documentId:ID.unique(),
        data: tweetModel.toJson(),
      );
      return right(res);
    } on AppwriteException catch (e, str) {
      return left(Failure(e.message ?? 'Unexpected error occurred', str));
    } catch (e, str) {
      return left(Failure(e.toString(), str));
    }
  }
}
