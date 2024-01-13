// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/services/api_comment.dart';
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
  bool showComments = false;

  TextEditingController commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    initGalleryDetail();
    initPrefs();
    loadComments();
  }

  void initGalleryDetail() {
    galleryDetailFuture =
        GalleryService.getGallery(context, widget.id).then((galleryData) {
      final gallery = GalleryModel.fromJson(galleryData);
      return gallery;
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

  Future<void> loadComments() async {
    try {
      final List<Map<String, dynamic>> commentList =
          await CommentService.getCommentList(widget.id.toString());
      setState(() {
        comments = commentList;
      });
    } catch (e) {
      print('Error loading comments: $e');
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

  Future<void> sendComment() async {
    try {
      final content = commentController.text;
      await CommentService.createComment(
          context, widget.id.toString(), content);
      await loadComments();

      commentController.clear();
    } catch (e) {
      print('Error sending comment: $e');
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
            onPressed: () {
              setState(() {
                showComments = !showComments;
              });
            },
            icon: const Icon(Icons.comment),
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
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.photo),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          const SizedBox(height: 10),
                          if (gallery != null)
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                itemCount: gallery.contents.length,
                                itemBuilder: (context, index) {
                                  final content = gallery.contents[index];
                                  return AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      content,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  if (showComments)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (Map<String, dynamic> comment in comments)
                          ListTile(
                            title: Text(comment['member']['name'] as String),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  comment['member']['photo'] as String),
                            ),
                            subtitle: Text(comment['content'] as String),
                          ),
                        const SizedBox(height: 8),
                        // 댓글 입력 폼
                        TextFormField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            labelText: 'Add a comment...',
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: sendComment,
                          child: const Text('Send Comment'),
                        ),
                      ],
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
