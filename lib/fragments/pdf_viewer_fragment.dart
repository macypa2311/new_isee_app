import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerFragment extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerFragment({
    Key? key,
    required this.pdfUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}