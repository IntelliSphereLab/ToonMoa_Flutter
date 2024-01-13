// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LikeService {
  static const baseUrl = "http://localhost:4000";

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

    if (response.statusCode == 200) {
      _showLikeSuccessSnackbar(context, "좋아요");
    } else {
      throw Exception('Failed to handle like');
    }
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

  static void _showLikeSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
