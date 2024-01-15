// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_final_fields

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
  ScrollController _scrollController = ScrollController();

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
      backgroundColor: const Color(0xFFEC6982),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        title: const Text(
          "TOONQUIRREL",
          style: TextStyle(fontSize: 24, fontFamily: 'TTMilksCasualPie'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.photo),
                ),
                const SizedBox(width: 15),
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                              height: 400,
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: onHeartTap,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showComments = !showComments;
                            if (showComments) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _scrollController.animateTo(
                                0.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.comment,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (Map<String, dynamic> comment in comments)
                          ListTile(
                            title: Text(
                              comment['member']['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  comment['member']['photo'] as String),
                            ),
                            subtitle: Text(
                              comment['content'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ]),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + 200,
                    child: Visibility(
                      visible: showComments,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Write Something!',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: sendComment,
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
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
