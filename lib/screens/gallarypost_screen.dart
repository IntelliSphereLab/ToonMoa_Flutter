// ignore_for_file: library_private_types_in_public_api, avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/services/api_gellary.dart';
import 'package:toonquirrel/services/api_login.dart';
import 'package:toonquirrel/widgets/photo_widget.dart';

class GalleryPostScreen extends StatefulWidget {
  const GalleryPostScreen({super.key});

  @override
  _GalleryPostScreenState createState() => _GalleryPostScreenState();
}

class _GalleryPostScreenState extends State<GalleryPostScreen> {
  final TextEditingController messageController = TextEditingController();
  final List<File> files = [];
  String email = '';
  List<GalleryModel> galleryList = [];

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void getEmail() async {
    try {
      final emailResponse = await KakaoService.getEmail();
      setState(() {
        email = emailResponse!;
      });
    } catch (error) {
      rethrow;
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _createGallery() async {
    try {
      if (files.isNotEmpty) {
        final response =
            await GalleryService.createGallery(context, email, files);
        Navigator.pop(context, true);
      } else {
        _showSnackbar('사진을 선택하세요.');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _selectPhotos() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      setState(() {
        files.add(imageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        title: const Text(
          "TOONQUIRREL",
          style: TextStyle(fontSize: 24, fontFamily: 'TTMilksCasualPie'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ToonBasic.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 260),
              child: Column(
                children: [
                  SelectedPhotos(file: files.isNotEmpty ? files[0] : null),
                  ElevatedButton(
                    onPressed: () {
                      _selectPhotos();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: Color(0xFFEC6982),
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: messageController,
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createGallery();
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.post_add,
          color: Color(0xFFEC6982),
          size: 36,
        ),
      ),
    );
  }
}
