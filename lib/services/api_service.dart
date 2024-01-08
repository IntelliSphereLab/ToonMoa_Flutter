// ignore_for_file: collection_methods_unrelated_type

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      // "https://toonquirrel-6d963f237af9.herokuapp.com";
      "http://localhost:4000";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(instance);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }

  static Future<bool> loginWithKakao() async {
    try {
      var uri = Uri.parse('http://localhost:4000/member/kakao/callback');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        // 응답이 성공적으로 받아왔을 때 데이터 처리

        // 이제 responseData를 사용하여 데이터 처리
        return true;
      } else {
        // 서버에서 오류 응답을 받았을 때 처리
        print("HTTP 오류: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // 예외 처리
      print("오류가 발생했습니다: $e");
      return false;
    }
  }

  static Future<bool> loginWithGoogle(String googleToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': googleToken}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
