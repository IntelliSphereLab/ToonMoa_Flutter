// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/services/api_gellary.dart';
import 'package:toonquirrel/widgets/gallery_widget.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key});

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

    GalleryService.getGallerys(page: currentPage, perPage: itemsPerPage)
        .then((initialGallerys) {
      setState(() {
        galleryList = initialGallerys;
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

      GalleryService.getGallerys(page: currentPage, perPage: itemsPerPage)
          .then((newGallerys) {
        if (newGallerys.isEmpty) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            galleryList.addAll(newGallerys);
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
                  return GalleryWidget(
                    id: gallery.id,
                    name: gallery.name,
                    photo: gallery.photo,
                    contents: gallery.contents,
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
    );
  }
}
