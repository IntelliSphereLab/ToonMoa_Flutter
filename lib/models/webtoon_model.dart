class WebtoonModel {
  final String title, thumb, id, author, url, date;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : url = json["url"],
        title = json['title'],
        thumb = json['img'],
        id = json['_id'],
        author = json["author"],
        date = json['updateDays'];
}
