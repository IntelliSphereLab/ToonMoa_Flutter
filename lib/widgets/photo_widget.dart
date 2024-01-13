import 'dart:io';

import 'package:flutter/material.dart';

class SelectedPhotos extends StatelessWidget {
  const SelectedPhotos({super.key, this.file});
  final File? file;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              offset: const Offset(10, 10),
              color: Colors.black.withOpacity(0.3),
            )
          ],
        ),
        child: Image.file(
          file!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              offset: const Offset(10, 10),
              color: Colors.black.withOpacity(0.3),
            )
          ],
        ),
        child: Image.asset(
          'assets/ToonStart.png',
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
