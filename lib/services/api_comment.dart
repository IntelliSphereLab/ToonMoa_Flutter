// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class CommentService {
  static const baseUrl =
      "https://toonquirrel-the-app-server-499b0fb941a5.herokuapp.com";

  static Future<Map<String, dynamic>> createComment(
      BuildContext context, String galleryId, String content) async {
    User user = await UserApi.instance.me();
    final email = user.kakaoAccount!.email;
    final url = Uri.parse('$baseUrl/comment');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'galleryId': galleryId,
        'content': content,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to create comment');
    }
  }

  static Future<List<Map<String, dynamic>>> getCommentList(
      String galleryId) async {
    final url = Uri.parse('$baseUrl/comment/get');
    final response = await http.post(
      url,
      body: {
        'galleryId': galleryId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> comments =
          data.cast<Map<String, dynamic>>();
      return comments;
    } else {
      throw Exception('Failed to get comment list');
    }
  }

  static Future<String> updateComment(
      BuildContext context, String commentId, String content) async {
    final url = Uri.parse('$baseUrl/comment/$commentId');
    final response = await http.patch(
      url,
      body: {
        'content': content,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final message = data['message'] as String;
      return message;
    } else {
      throw Exception('Failed to update comment');
    }
  }

  static Future<String> deleteComment(
      BuildContext context, String commentId) async {
    final url = Uri.parse('$baseUrl/comment/$commentId');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final message = data['message'] as String;
      return message;
    } else {
      throw Exception('Failed to delete comment');
    }
  }
}
