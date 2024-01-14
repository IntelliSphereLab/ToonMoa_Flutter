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
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상 지정
                    width: 1, // 테두리 두께 지정
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 1, // 이미지 비율 유지
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      firstContents,
                      fit: BoxFit.cover, // 이미지를 비율 유지하면서 채우도록 설정
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
