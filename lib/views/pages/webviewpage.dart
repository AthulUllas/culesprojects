import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key, required this.webViewUrl});

  final String webViewUrl;

  late final webViewController =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..clearLocalStorage()
        ..loadRequest(Uri.parse(webViewUrl));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: SafeArea(child: WebViewWidget(controller: webViewController)),
    );
  }
}
