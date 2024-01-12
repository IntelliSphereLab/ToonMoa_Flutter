// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Episode extends StatefulWidget {
  final String initialUrl;
  final String title;
  const Episode({super.key, required this.initialUrl, required this.title});

  @override
  State<Episode> createState() => _Episode();
}

class _Episode extends State<Episode> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.initialUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFFEC6982),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
