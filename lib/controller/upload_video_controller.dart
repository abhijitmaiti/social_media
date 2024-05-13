import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record_and_upload/model/video.dart';
import 'package:record_and_upload/view/screens/Home.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

class VideoUploadController extends GetxController {
  static VideoUploadController instance = Get.find();
  var uuid = Uuid();

  Future<File> _getThumb(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadVideoThumbToStorage(String id, String videoPath) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("thumbnail").child(id);
    UploadTask uploadTask = reference.putFile(await _getThumb(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String videoName, String caption, String category,
      String videoPath, String location) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      String id = uuid.v1();
      String videoUrl = await _uploadVideoToStorage(id, videoPath);

      String thumbnail = await _uploadVideoThumbToStorage(id, videoPath);

      Video video = Video(
          location: location,
          uid: uid,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          videoName: videoName,
          category: category,
          shareCount: 0,
          commentsCount: 0,
          likes: [],
          caption: caption,
          id: id);
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(id)
          .set(video.toJson());
      Get.snackbar(
          "Video Uploaded Successfully", "Thank You Sharing Your Content",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black);
      Get.to(HomeScreen());
    } catch (e) {
      print(e);
      Get.snackbar("Error Uploading Video", e.toString());
    }
  }

  Future<String> _uploadVideoToStorage(String videoID, String videoPath) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("videos").child(videoID);
    UploadTask uploadTask = reference.putFile(await _compressVideo(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }
}
