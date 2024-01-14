import 'dart:io';

import 'package:flutter/material.dart';

class SelectedPhotos extends StatelessWidget {
  const SelectedPhotos({super.key, this.file});
  final File? file;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.file(
          file!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          'assets/ToonNoImage.png',
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
