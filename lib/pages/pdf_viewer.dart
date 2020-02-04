import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class FullPdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  FullPdfViewerScreen(this.pdfPath);

  @override
  Widget build(BuildContext context) {
    print(["pdfPath", pdfPath]);
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
        ),
        path: pdfPath);
  }
}