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
  late Future<GalleryModel> webtoonDetailFuture;
  late SharedPreferences prefs;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    webtoonDetailFuture = GalleryService.getGalleryDetail(widget.id);
    initPrefs();
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
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.star : Icons.star_border_outlined,
            ),
          )
        ],
        title: const Text(
          "TOONQUIRREL",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 300,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.3),
                          )
                        ],
                      ),
                      child: Image.network(widget.photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder<GalleryModel>(
                future: webtoonDetailFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Author: ${widget.name}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Date: ${widget.photo}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
