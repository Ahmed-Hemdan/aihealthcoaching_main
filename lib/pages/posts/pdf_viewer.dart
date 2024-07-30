import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFScreen extends StatefulWidget {
  final String fileUrl;
  const PDFScreen({required this.fileUrl}) : super();

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool _isLoading = true;
  late PDFDocument document;
  changePDF() async {
    setState(() => _isLoading = true);
    document = await PDFDocument.fromURL(
      widget.fileUrl,
    );

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    changePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Preview File',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xff123456),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: PDFViewer(
                document: document,
                zoomSteps: 1,
              ),
            ),
    );
  }
}
