class AppWriteConstants {
  static String databaseId = "67208fd300215e281d88";
  static String projectId = "67208dbd00050ef07362";
  static String endpoint = "http://192.168.100.4:80/v1";
  static String userCollectionId = "6726799e00068cab1b04";
  static String tweetCollectionId = "672d0989000ef6afcd9f";
  static String tweetBucket = "672dd6340037c540ea85";

  static String imageLinkGetter(String imageUrl) =>
      "$endpoint/storage/buckets/$tweetBucket/files/$imageUrl/view?project=$projectId=$projectId&mode=admin";
}
