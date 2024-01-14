// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/screens/milestone_screen.dart';
import 'package:toonquirrel/services/api_gellary.dart';
import 'package:toonquirrel/services/api_login.dart';
import 'package:toonquirrel/widgets/mygallery_widget.dart';

class MyGalleryScreen extends StatefulWidget {
  const MyGalleryScreen({super.key});

  @override
  _MyGalleryScreenState createState() => _MyGalleryScreenState();
}

class _MyGalleryScreenState extends State<MyGalleryScreen> {
  List<GalleryModel> galleryList = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isLoading = false;
  String email = "";

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  Future<void> getEmail() async {
    try {
      final emailResponse = await KakaoService.getEmail();
      setState(() {
        email = emailResponse ?? "";
      });
      loadInitialData();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final initialGalleries =
          await GalleryService.getMyGallery(context, email, currentPage);
      setState(() {
        galleryList = initialGalleries
            .map((galleryData) => GalleryModel.fromJson(galleryData))
            .toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadNextPage() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });

      try {
        final newGalleries =
            await GalleryService.getMyGallery(context, email, currentPage);
        if (newGalleries.isNotEmpty) {
          setState(() {
            galleryList.addAll(newGalleries
                .map((galleryData) => GalleryModel.fromJson(galleryData)));
          });
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        title: const Text(
          "TOONQUIRREL",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'TTMilksCasualPie'
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MilestoneScreen()),
          );
          return false;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              if (scrollNotification.metrics.pixels >=
                  scrollNotification.metrics.maxScrollExtent) {
                loadNextPage();
              }
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: galleryList.length,
                  itemBuilder: (context, index) {
                    var gallery = galleryList[index];
                    String firstContents =
                        gallery.contents.isNotEmpty ? gallery.contents[0] : '';
                    return MyGalleryWidget(
                      id: gallery.id,
                      name: gallery.name,
                      photo: gallery.photo,
                      contents: [firstContents],
                    );
                  },
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
