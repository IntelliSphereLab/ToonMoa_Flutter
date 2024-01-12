// ignore_for_file: collection_methods_unrelated_type, use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonquirrel/models/webtoon_model.dart';

class ApiService {
  static const baseUrl = "http://localhost:4000";

  static Future<List<WebtoonModel>> getKakaoToons(
      {required int page, required int perPage}) async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/toon/kakao');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List) {
        for (var webtoonData in responseData) {
          final instance = WebtoonModel.fromJson(webtoonData);
          webtoonInstances.add(instance);
        }
        return webtoonInstances;
      }
    }
    throw Error();
  }

  static Future<List<WebtoonModel>> getNaverToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/toon/naver');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List) {
        for (var webtoonData in responseData) {
          final instance = WebtoonModel.fromJson(webtoonData);
          webtoonInstances.add(instance);
        }
        return webtoonInstances;
      }
    }
    throw Error();
  }

  static Future<List<WebtoonModel>> getKakaoToonByDate(String date) async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/toon/naver/$date');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List) {
        for (var webtoonData in responseData) {
          final instance = WebtoonModel.fromJson(webtoonData);
          webtoonInstances.add(instance);
        }
        return webtoonInstances;
      }
    }
    throw Error();
  }

  static Future<List<WebtoonModel>> getNaverToonByDate(String date) async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/toon/naver/$date');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List) {
        for (var webtoonData in responseData) {
          final instance = WebtoonModel.fromJson(webtoonData);
          webtoonInstances.add(instance);
        }
        return webtoonInstances;
      }
    }
    throw Error();
  }

  static Future<WebtoonModel> getEpisode(String title) async {
    final url = Uri.parse('$baseUrl/toon/$title');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final webtoonDeta = WebtoonModel.fromJson(responseData);
      return webtoonDeta;
    } else {
      throw Exception('Failed to load webtoon detail: ${response.statusCode}');
    }
  }
}
