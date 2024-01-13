class GalleryModel {
  final int id;
  final String photo, name;
  final List<String> contents;

  GalleryModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        contents = List<String>.from(json["contents"]),
        name = json["member"]["name"],
        photo = json["member"]["photo"];
}
