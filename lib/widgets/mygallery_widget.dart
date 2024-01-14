// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:toonquirrel/screens/gallaryedit_screen.dart';
import 'package:toonquirrel/screens/gallerydetail_screen.dart';
import 'package:toonquirrel/screens/galleryme_screen.dart';
import 'package:toonquirrel/services/api_gellary.dart';

class MyGalleryWidget extends StatelessWidget {
  final int id;
  final String name;
  final String photo;
  final List<String> contents;

  const MyGalleryWidget({
    super.key,
    required this.id,
    required this.name,
    required this.photo,
    required this.contents,
  });

  Future<String?> getEmail() async {
    try {
      final user = await UserApi.instance.me();
      final email = user.kakaoAccount!.email;
      return email;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _deleteGallery(BuildContext context, String galleryId) async {
    final email = await getEmail();
    await GalleryService.deleteGallery(email!, galleryId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailScreen(
              contents: contents,
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
            Container(
              margin: const EdgeInsets.all(2),
              child: Hero(
                tag: id,
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  elevation: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Image.network(contents.isNotEmpty ? contents[0] : "",
                            width: 200, height: 200, fit: BoxFit.cover),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GalleryEditScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteGallery(context, id.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyGalleryScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
