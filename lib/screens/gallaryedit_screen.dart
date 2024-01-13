// ignore_for_file: library_private_types_in_public_api, avoid_print, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:toonquirrel/screens/milestone_screen.dart';
import 'package:toonquirrel/services/api_gellary.dart';
import 'package:toonquirrel/services/api_login.dart';
import 'package:toonquirrel/widgets/gallery_widget.dart';
import 'package:toonquirrel/widgets/photo_widget.dart';

class GalleryEditScreen extends StatefulWidget {
  const GalleryEditScreen({super.key});

  @override
  _GalleryEditScreenState createState() => _GalleryEditScreenState();
}

class _GalleryEditScreenState extends State<GalleryEditScreen> {
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

  Future<void> _editGallery() async {
    try {
      if (files.isNotEmpty) {
        final response = await GalleryService.updateGallery(
          context,
          email,
          files.map((file) => file.path).toList(),
          galleryList.isNotEmpty ? galleryList[0].id.toString() : '',
        );
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
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectedPhotos(file: files.isNotEmpty ? files[0] : null),
          ElevatedButton(
            onPressed: () {
              _selectPhotos();
            },
            child: const Text('Select Photos'),
          ),
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
          TextFormField(
            controller: messageController,
            decoration: const InputDecoration(labelText: '쓰고 싶은 말'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _editGallery();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MilestoneScreen()),
              );
            },
            child: const Text('Edit MyGallery'),
          ),
        ],
      ),
    );
  }
}
