import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FilePreviewDocScreen extends StatefulWidget {
  final String filePath;

  const FilePreviewDocScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _FilePreviewDocScreenState createState() => _FilePreviewDocScreenState();
}

class _FilePreviewDocScreenState extends State<FilePreviewDocScreen> {

  @override
  Widget build(BuildContext context) {


    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          widget.filePath));

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ Keeps the status bar transparent
        statusBarIconBrightness: Brightness.light, // ✅ White icons on dark backgrounds
        statusBarBrightness: Brightness.dark, // ✅ Ensures compatibility on iOS
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath.split('/').last),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}
