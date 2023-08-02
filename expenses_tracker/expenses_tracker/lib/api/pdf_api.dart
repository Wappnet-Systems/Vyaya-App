import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    log("$file");
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
   if (await file.exists()) {
    log("File Saved Successfully");
  } else {
    throw 'File not found';
  }
  }
}