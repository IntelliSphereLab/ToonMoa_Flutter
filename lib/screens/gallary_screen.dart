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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadInitialData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            galleryList.addAll(newGalleries);
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: galleryList.length,
                  itemBuilder: (context, index) {
                    var gallery = galleryList[index];
                    String firstContents =
                        gallery.contents.isNotEmpty ? gallery.contents[0] : '';
                    return GalleryWidget(
                      id: gallery.id,
                      name: gallery.name,
                      photo: gallery.photo,
                      firstContents: firstContents,
                    );
                  },
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
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
