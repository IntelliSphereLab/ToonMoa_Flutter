import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/gallerydetail_screen.dart';

class GalleryWidget extends StatelessWidget {
  final int id;
  final String name;
  final String photo;
  final List<String> contents;

  const GalleryWidget({
    super.key,
    required this.id,
    required this.name,
    required this.photo,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailScreen(
                contents: contents, id: id, name: name, photo: photo),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 250,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: const Offset(10, 10),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              child: Image.network(contents.isNotEmpty ? contents[0] : ""),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Text(
          //   name,
          //   style: const TextStyle(
          //     fontSize: 22,
          //   ),
          // ),
        ],
      ),
    );
  }
}
