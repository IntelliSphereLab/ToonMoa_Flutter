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

  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final initialGalleries =
          await GalleryService.getAllGallery(context, currentPage);
      setState(() {
        galleryList = initialGalleries;
        isLoading = false;
      });
    } catch (e) {
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
            await GalleryService.getAllGallery(context, currentPage);
        if (newGalleries.isNotEmpty) {
          setState(() {
            galleryList.addAll(newGalleries);
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
            fontFamily: 'TTMilksCasualPie',
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ToonHeart.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
            MaterialPageRoute(
              builder: (context) => const GalleryPostScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFEC6982),
        child: const Icon(
          Icons.photo_camera,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
