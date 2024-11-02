import 'package:flutter/cupertino.dart';

@immutable
class UserModel {
  final String name;
  final String email;
  final String uid;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final bool isBlue;
  final List<String> followers;
  final List<String> following;

  const UserModel({
    required this.profilePic,
    required this.followers,
    required this.following,
    required this.bannerPic,
    required this.bio,
    required this.isBlue,
    required this.name,
    required this.email,
    required this.uid,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
    String? profilePic,
    String? bannerPic,
    String? bio,
    bool? isBlue,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
        profilePic: profilePic ?? this.profilePic,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        bannerPic: bannerPic ?? this.bannerPic,
        bio: bio ?? this.bio,
        isBlue: isBlue ?? this.isBlue,
        name: name ?? this.name,
        email: email ?? this.email,
        uid: uid ?? this.uid);
  }

  Map<String, dynamic> toMap() {
    final res = <String, dynamic>{};

    ///uid is not needed here because it gets generated automatically by app write
    res.addAll({'email': email});
    res.addAll({'name': name});
    res.addAll({'followers': followers});
    res.addAll({'following': following});
    res.addAll({'bio': bio});
    res.addAll({'banner_pic': bannerPic});
    res.addAll({'profile_pic': profilePic});
    res.addAll({'is_blue': isBlue});
    return res;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        profilePic: map['profile_pic'] ?? '',
        followers: List<String>.from(map['followers']),
        following: List<String>.from(map['following']),
        bannerPic: map['banner_pic'] ?? '',
        bio: map['bio'] ?? '',
        isBlue: map['is_blue'] ?? false,
        name: map['name'] ?? '',
        email: map['email'] ?? '',

        ///in app write uid gets saved as $id
        uid: map['\$uid'] ?? '');
  }
}
