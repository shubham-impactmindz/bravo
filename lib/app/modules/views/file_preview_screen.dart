import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FilePreviewScreen extends StatefulWidget {
  final String filePath;

  const FilePreviewScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _FilePreviewScreenState createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.filePath.split('/').last)),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) {
              setState(() {
                _totalPages = pages!;
                _isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                _errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                _errorMessage = "Error on page $page: $error";
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              setState(() {
                _isReady = true;
              });
            },
            onPageChanged: (page, total) {
              setState(() {
                _currentPage = page!;
              });
            },
          ),
          if (!_isReady)
            Center(child: CircularProgressIndicator()),
          if (_errorMessage.isNotEmpty)
            Center(
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
