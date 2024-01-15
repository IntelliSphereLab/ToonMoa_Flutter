// ignore_for_file: use_build_context_synchronously, unused_element, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toonquirrel/models/gallery_model.dart';

class GalleryService {
  static const baseUrl =
      "https://toonquirrel-the-app-server-499b0fb941a5.herokuapp.com";

  static Future<Map<String, dynamic>> createGallery(
    BuildContext context,
    String email,
    List<File> files,
  ) async {
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
      return data;
    } else {
      throw Exception('Failed to create gallery');
    }
  }

  static Future<Map<String, dynamic>> getGallery(
      BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else if (response.statusCode == 404) {
      throw Exception('Gallery not found');
    } else {
      throw Exception('Failed to get gallery by ID');
    }
  }

  static Future<List<GalleryModel>> getAllGallery(
      BuildContext context, int page) async {
    final url = Uri.parse('$baseUrl/all');
    final response = await http.post(
      url,
      body: {
        'page': page.toString(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<GalleryModel> galleries = data
          .map((data) => GalleryModel.fromJson(data as Map<String, dynamic>))
          .toList();

      return galleries;
    } else {
      throw Exception('Failed to get all galleries');
    }
  }

  static Future<List<Map<String, dynamic>>> getMyGallery(
      BuildContext context, String email, int page) async {
    final url = Uri.parse('$baseUrl/my');
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
      return data;
    } else {
      throw Exception('Failed to update gallery');
    }
  }

  static Future<void> deleteGallery(String email, String galleryId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete'),
        body: {
          'email': email,
          'galleryId': galleryId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
