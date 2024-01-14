// ignore_for_file: library_private_types_in_public_api

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getEmail();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            color: Colors.white,
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
        child: WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MilestoneScreen()),
            );
            return false;
          },
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
              return MyGalleryWidget(
                id: gallery.id,
                name: gallery.name,
                photo: gallery.photo,
                contents: [firstContents],
              );
            },
          ),
        ),
      ),
    );
  }
}
