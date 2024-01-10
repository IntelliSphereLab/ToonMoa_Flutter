class WebtoonModel {
  final String? title, thumb, id, author;
  // final int? webtoonId;
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['img'],
        id = json['_id'],
        author = json["author"];
  // webtoonId = json['webtoonId'];
}
