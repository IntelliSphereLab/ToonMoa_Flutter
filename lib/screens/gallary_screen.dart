// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/screens/gallarypost_screen.dart';
import 'package:toonquirrel/services/api_gellary.dart';
import 'package:toonquirrel/widgets/gallery_widget.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<GalleryModel> galleryList = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    setState(() {
      isLoading = true;
    });

    GalleryService.getAllGallery(context, currentPage).then((initialGalleries) {
      setState(() {
        galleryList = initialGalleries;
        isLoading = false;
      });
    });
  }

  void loadNextPage() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });

      GalleryService.getAllGallery(context, currentPage).then((newGalleries) {
        if (newGalleries.isEmpty) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            galleryList.addAll(
              List<GalleryModel>.from(newGalleries.map((galleryData) =>
                  GalleryModel.fromJson(galleryData as Map<String, dynamic>))),
            );
            isLoading = false;
          });
        }
      });
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
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
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
                  return GalleryWidget(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GalleryPostScreen()),
          );
        },
        backgroundColor: const Color(0xFFEC6982),
        child: const Icon(Icons.add),
      ),
    );
  }
}
