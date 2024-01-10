// ignore_for_file: collection_methods_unrelated_type, use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonquirrel/models/webtoon_detail_model.dart';
import 'package:toonquirrel/models/webtoon_episode_model.dart';
import 'package:toonquirrel/models/webtoon_model.dart';

class ApiService {
  static const baseUrl = "http://localhost:4000";

  static Future<List<WebtoonModel>> getKakaoToons() async {
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
}
