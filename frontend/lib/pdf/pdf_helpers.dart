import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:typed_data';
import 'dart:js' as js;
import 'dart:html' as html;

class PdfApi {
  static Future<Uint8List> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    return bytes;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
