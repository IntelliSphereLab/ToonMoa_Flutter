import 'package:flutter/material.dart';
import 'package:toonquirrel/screens/gallerydetail_screen.dart';

class GalleryWidget extends StatelessWidget {
  final int id;
  final String name;
  final String photo;
  final String firstContents;

  const GalleryWidget({
    super.key,
    required this.id,
    required this.name,
    required this.photo,
    required this.firstContents,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailScreen(
              contents: [firstContents],
              id: id,
              name: name,
              photo: photo,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: id,
              child: Container(
                width: 250,
                margin: const EdgeInsets.all(2),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      firstContents,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
