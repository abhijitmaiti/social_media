import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Video {
  String uid;
  String id;
  List likes;
  int commentsCount;
  int shareCount;
  String videoName;
  String caption;
  String category;
  String location;
  String videoUrl;
  String thumbnail;

  Video(
      {required this.uid,
      required this.location,
      required this.category,
      required this.thumbnail,
      required this.caption,
      required this.commentsCount,
      required this.id,
      required this.likes,
      required this.shareCount,
      required this.videoName,
      required this.videoUrl});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "id": id,
        "likes": likes,
        "location":location,
        "commentsCount": commentsCount,
        "shareCount": shareCount,
        "videoName": videoName,
        "caption": caption,
        "category": category,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var sst = snap.data() as Map<String, dynamic>;

    return Video(
        uid: sst["uid"],
        location: sst["location"],
        id: sst["id"],
        likes: sst["likes"],
        commentsCount: sst['commentsCount'],
        caption: sst["caption"],
        shareCount: sst["shareCount"],
        videoName: sst["videoName"],
        category: sst["category"],
        thumbnail: sst["thumbnail"],
        videoUrl: sst["videoUrl"]);
  }
}
