import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import '../../controller/upload_video_controller.dart';

class addCaption_Screen extends StatefulWidget {
  File videoFile;
  String videoPath;

  addCaption_Screen(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  @override
  State<addCaption_Screen> createState() => _addCaption_ScreenState();
}

class _addCaption_ScreenState extends State<addCaption_Screen> {
  late VideoPlayerController videoPlayerController;
  String location =
      "Tap here to get location wefwe wefwef wefwefewf wefwefewf wefwefe";

  VideoUploadController videoUploadController =
      Get.put(VideoUploadController());
  TextEditingController videoNameController = new TextEditingController();
  TextEditingController captionController = new TextEditingController();
  TextEditingController catagoryController = new TextEditingController();

  Widget UploadContent = Text("Upload");

  uploadVid() {
    UploadContent = Text("Please Wait..");
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      videoPlayerController = VideoPlayerController.file(widget.videoFile);
    });
    videoPlayerController.initialize();
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: VideoPlayer(videoPlayerController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .50,
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextInputField(
                        controller: videoNameController,
                        myIcon: Icons.music_note,
                        myLabelText: "Video Name"),
                    SizedBox(
                      height: 20,
                    ),
                    TextInputField(
                        controller: captionController,
                        myIcon: Icons.closed_caption,
                        myLabelText: "Video Description"),
                    SizedBox(
                      height: 20,
                    ),
                    TextInputField(
                      controller: catagoryController,
                      myIcon: Icons.category,
                      myLabelText: "Catagory",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Position position = await _determinePosition();

                        location =
                            "Lat=${position.latitude} & Long=${position.longitude}";

                        uploadVid();
                        videoUploadController.uploadVideo(
                          videoNameController.text,
                          captionController.text,
                          catagoryController.text,
                          widget.videoPath,
                          location,
                        );
                        setState(() {});
                      },
                      child: UploadContent,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
// upload video textFeild class
class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData myIcon;
  final String myLabelText;
  final bool toHide;
  TextInputField({
    Key? key,
    required this.controller,
    required this.myIcon,
    required this.myLabelText,
    this.toHide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(myIcon),
        labelText: myLabelText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.white70,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
