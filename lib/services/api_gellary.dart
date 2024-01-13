import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toonquirrel/models/gallery_model.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class GalleryService {
  static const baseUrl = "http://localhost:4000";

  static Future<List<GalleryModel>> getGallerys(
      {required int page, required int perPage}) async {
    User user = await UserApi.instance.me();
    final email = user.kakaoAccount!.email;
    List<GalleryModel> galleryInstances = [];
    final url = Uri.parse('$baseUrl/gallery/getMy');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, "page": page}),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is List) {
        for (var webtoonData in responseData) {
          final instance = GalleryModel.fromJson(webtoonData);
          galleryInstances.add(instance);
        }
        return galleryInstances;
      }
    }
    throw Error();
  }

  static Future<GalleryModel> getGalleryDetail(int id) async {
    User user = await UserApi.instance.me();
    final email = user.kakaoAccount!.email;
    final url = Uri.parse('$baseUrl/gallery/getDetail');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, "galleryId": id}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final galleryDeta = GalleryModel.fromJson(responseData);
      return galleryDeta;
    } else {
      throw Exception('Failed to load webtoon detail: ${response.statusCode}');
    }
  }
}
