// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LikeService {
  static const baseUrl =
      "https://toonquirrel-the-app-server-499b0fb941a5.herokuapp.com";

  static Future<void> handleLike(
      String email, String galleryId, BuildContext context) async {
    final url = Uri.parse('$baseUrl/like');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'galleryId': galleryId,
      },
    );
  }

  static Future<int> getCount(String galleryId) async {
    final url = Uri.parse('$baseUrl/like/get');
    final response = await http.post(
      url,
      body: {
        'galleryId': galleryId,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final count = data['count'] as int;
      return count;
    } else {
      throw Exception('Failed to get like count');
    }
  }
}
