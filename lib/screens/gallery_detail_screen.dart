// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/services/api_gellary.dart';

class GalleryDetailScreen extends StatefulWidget {
  final int id;
  final String name;
  final String photo;
  final List<String> contents;

  const GalleryDetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.photo,
    required this.contents,
  });

  @override
  _GalleryDetailScreenState createState() => _GalleryDetailScreenState();
}

class _GalleryDetailScreenState extends State<GalleryDetailScreen> {
  late Future<GalleryModel?> galleryDetailFuture;
  late SharedPreferences prefs;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    initGalleryDetail();
    initPrefs();
  }

  Future<void> initGalleryDetail() async {
    final galleryData = await GalleryService.getGalleryById(context, widget.id);
    final gallery = GalleryModel.fromJson(galleryData);
    setState(() {
      galleryDetailFuture = Future.value(gallery);
    });
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedGallery = prefs.getStringList('likedGallery');
    if (likedGallery != null) {
      if (likedGallery.contains(widget.id.toString())) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedGallery', []);
    }
  }

  onHeartTap() async {
    final likedGallery = prefs.getStringList('likedGallery');
    if (likedGallery != null) {
      if (isLiked) {
        likedGallery.remove(widget.id.toString());
      } else {
        likedGallery.add(widget.id.toString());
      }
      await prefs.setStringList('likedGallery', likedGallery);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.photo,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<GalleryModel?>(
                    future: galleryDetailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final gallery = snapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Contents:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (gallery != null)
                            ...gallery.contents.map(
                              (content) {
                                return Text(
                                  content,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
