import 'package:flutter/material.dart';
import 'package:record_and_upload/view/screens/search_screen.dart';

import 'add_video.dart';
import 'display_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            pageIdx = index;
          });
        },
        currentIndex: pageIdx,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 25,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 25,
                color: Colors.white,
              ),
              label: 'Search'),
           const BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_rounded,
                size: 25,
                color: Colors.white,
              ),
              label: 'Upload'),
        ],
      ),
      body: Center(
        child: pageindex[pageIdx],
      ),
    );
  }
  var pageindex = [
  DisplayVideo_Screen(),
  SearchScreen(),
  addVideoScreen(),
  
];
}
