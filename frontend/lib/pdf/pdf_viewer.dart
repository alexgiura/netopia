import 'package:erp_frontend_v2/constants/style.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
// import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, required this.bytes});

  final Uint8List bytes;

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  //late PdfController pdfController;

  @override
  void initState() {
    super.initState();

    // pdfController = PdfController(
    //   document: PdfDocument.openData(widget.bytes),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.memory(
      widget.bytes,
    );
  }
}
