// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GalleryService {
  static const baseUrl = "http://localhost:4000/gallery";

  static Future<Map<String, dynamic>> createGallery(
      BuildContext context, String email, List<File> files) async {
    final url = Uri.parse('$baseUrl/create');

    final request = http.MultipartRequest('POST', url);
    request.fields['email'] = email;

    for (var file in files) {
      final fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
      final length = await file.length();

      final multipartFile = http.MultipartFile(
        'files',
        fileStream,
        length,
        filename: file.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _showGallerySuccessSnackbar(context, "포스트 생성 성공");
      return data;
    } else {
      throw Exception('Failed to create gallery');
    }
  }

  static Future<Map<String, dynamic>> getGalleryById(
      BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _showGallerySuccessSnackbar(context, "갤러리 조회 성공");
      return data;
    } else if (response.statusCode == 404) {
      _showGallerySuccessSnackbar(context, "갤러리 조회 실패");
      throw Exception('Gallery not found');
    } else {
      throw Exception('Failed to get gallery by ID');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllGallery(
      BuildContext context, int page) async {
    final url = Uri.parse('$baseUrl/getAll');
    final response = await http.post(
      url,
      body: {
        'page': page.toString(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> galleries =
          data.cast<Map<String, dynamic>>();
      _showGallerySuccessSnackbar(context, "갤러리 불러오기 성공");
      return galleries;
    } else {
      throw Exception('Failed to get all galleries');
    }
  }

  static Future<List<Map<String, dynamic>>> getMyGallery(
      BuildContext context, String email, int page) async {
    final url = Uri.parse('$baseUrl/getMy');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'page': page.toString(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> galleries =
          data.cast<Map<String, dynamic>>();
      _showGallerySuccessSnackbar(context, "내 포스트 불러오기 성공");
      return galleries;
    } else {
      throw Exception('Failed to get my galleries');
    }
  }

  static Future<Map<String, dynamic>> updateGallery(BuildContext context,
      String email, List<String> files, String galleryId) async {
    final url = Uri.parse('$baseUrl/update');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'files': jsonEncode(files),
        'galleryId': galleryId,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _showGallerySuccessSnackbar(context, "포스트 수정 성공");
      return data;
    } else {
      throw Exception('Failed to update gallery');
    }
  }

  static Future<Map<String, dynamic>> deleteGallery(
      BuildContext context, String email, String galleryId) async {
    final url = Uri.parse('$baseUrl/delete');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'galleryId': galleryId,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _showGallerySuccessSnackbar(context, "포스트 삭제 성공");
      return data;
    } else {
      throw Exception('Failed to delete gallery');
    }
  }

  static void _showGallerySuccessSnackbar(
      BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
