import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:record_and_upload/view/screens/addcaption_screen.dart';

class addVideoScreen extends StatelessWidget {
  addVideoScreen({Key? key}) : super(key: key);
  videoPick(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Get.snackbar(
        "Video Selected",
        video.path,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.white,
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => addCaption_Screen(
                  videoFile: File(video.path), videoPath: video.path)));
    } else {
      Get.snackbar(
          "Error In Selecting Video", "Please Choose A Different Video File",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          backgroundColor: Colors.white);
    }
  }

  showDialogOpt(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () => videoPick(ImageSource.gallery, context),
                  child: Text("Gallery"),
                ),
                SimpleDialogOption(
                  onPressed: () => videoPick(ImageSource.camera, context),
                  child: Text("Camera"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showDialogOpt(context),
          child: Container(
            width: MediaQuery.of(context).size.height * .30,
            height: MediaQuery.of(context).size.height * .30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.blue.shade200,
                  ]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                "Upload Vedio",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
