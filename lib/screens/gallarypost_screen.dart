// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/gallary_screen.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:toonquirrel/services/api_gellary.dart';

class GalleryPostScreen extends StatefulWidget {
  const GalleryPostScreen({super.key});

  @override
  _GalleryPostScreenState createState() => _GalleryPostScreenState();
}

class _GalleryPostScreenState extends State<GalleryPostScreen> {
  final TextEditingController messageController = TextEditingController();
  final List<http.MultipartFile> files = [];

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _createGallery() async {
    final message = messageController.text;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${GalleryService.baseUrl}/create'),
      );

      request.fields['message'] = message;

      for (var file in files) {
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        _showSnackbar('Gallery 생성 성공');
      } else {
        _showSnackbar('Gallery 생성 실패');
      }
    } catch (error) {
      _showSnackbar('Gallery 생성 실패: $error');
    }
  }

  Future<void> _selectFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        files.add(
          http.MultipartFile(
            'files',
            file.readStream!,
            file.size,
            filename: file.name,
          ),
        );
      }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _selectFiles();
              },
              child: const Text('Select Files'),
            ),
            TextFormField(
              controller: messageController,
              decoration: const InputDecoration(labelText: '쓰고 싶은 말'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createGallery();
              },
              child: const Text('Create Gallery'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GalleryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
