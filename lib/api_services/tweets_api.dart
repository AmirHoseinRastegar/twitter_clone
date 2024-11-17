import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/realtime_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetsApiProvider = Provider((ref) {
  final databases = ref.watch(appWriteDatabaseProvider);
  final realtime = ref.watch(appRealTimeProvider);
  return TweetsApiImpl(databases: databases, realtime: realtime);
});

abstract class TweetsApi {
  FutureEither<Document> shareTweet(TweetModel tweetModel);

  Future<List<Document>> getTweets();

  /// this realtime uses socket
  Stream<RealtimeMessage> getLatestTweets();
}

class TweetsApiImpl implements TweetsApi {
  final Databases _databases;
  final Realtime _realtime;

  TweetsApiImpl({required Databases databases, required Realtime realtime})
      : _realtime = realtime,
        _databases = databases;

  @override
  FutureEither<Document> shareTweet(TweetModel tweetModel) async {
    try {
      final res = await _databases.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetCollectionId,
        documentId: ID.unique(),
        data: tweetModel.toJson(),
      );
      return right(res);
    } on AppwriteException catch (e, str) {
      return left(Failure(e.message ?? 'Unexpected error occurred', str));
    } catch (e, str) {
      return left(Failure(e.toString(), str));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _databases.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetCollectionId,

        /// this is for getting latest tweets in the list of tweets in top of the screen
        queries: [
          ///for making it in descending order we need to add in in indexes section of our database adn make it
          /// as descending order in tweetedAt format so we set tweets according to tweetedAt
          Query.orderDesc('tweetedAt'),
        ]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweets() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetCollectionId}.documents'
    ]).stream;
  }
}
