import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FileViewWidget extends StatelessWidget {
  final String path;
  final String filename;
  FileViewWidget({Key? key, required this.path, required this.filename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          title: Text(
            filename,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.secondary)
          ),
          elevation: 5,
        ),
      body: PDFView(
        filePath: path,
        autoSpacing: false,
        pageSnap: true,
        swipeHorizontal: false,
      ),
    );
  }
}