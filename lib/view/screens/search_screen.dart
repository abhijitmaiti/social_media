import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_and_upload/model/video.dart';
import 'package:record_and_upload/view/screens/display_screen.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  TextEditingController searchItems = TextEditingController();

  final SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          title: TextFormField(
            decoration: InputDecoration(
                icon: const Icon(Icons.search),
                labelText: "Search Here",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 10, right: 15),
                hintText: "Search Username"),
            controller: searchItems,
            onChanged: (value) {
              searchController.searchVideo(value);
            },
          ),
        ),
        body: searchController.searchedVideoItem.isEmpty
            ? const Center(
                child: Text("No Result Found"),
              )
            : ListView.builder(
        
                itemCount: searchController.searchedVideoItem.length,
                itemBuilder: (context, index) {
                  Video item = searchController.searchedVideoItem[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayVideo_Screen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                          leading: Image(image: NetworkImage(item.thumbnail)),
                          title: Text(item.videoName),
                          subtitle: Text(item.caption)),
                    ),
                  );
                }),
      );
    });
  }
}
// serach part 
class SearchController extends GetxController {
  final Rx<List<Video>> searchItem = Rx<List<Video>>([]);

  List<Video> get searchedVideoItem => searchItem.value;

  searchVideo(String item) async {
    searchItem.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .where("videoName", isGreaterThanOrEqualTo: item)
        .snapshots()
        .map((QuerySnapshot items) {
      List<Video> retVal = [];
      for (var element in items.docs) {
        retVal.add(Video.fromSnap(element));
      }
      return retVal;
    }));
  }
}
