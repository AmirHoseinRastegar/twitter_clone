import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';

final appWriteClientProvider = Provider((ref) {
  final Client client = Client();
  return client
      .setEndpoint(AppWriteConstants.endpoint)
      .setProject(AppWriteConstants.projectId)
      .setSelfSigned(status: true);
});
final appWriteAccountProvider = Provider((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Account(client);
});

final appWriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Databases(client);
});
final appStorageProvider = Provider((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Storage(client);
});final appRealTimeProvider = Provider((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Realtime(client);
});
