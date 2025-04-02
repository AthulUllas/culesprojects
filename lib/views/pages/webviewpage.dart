import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key, required this.webViewUrl, required this.appBarTitle});

  final Uri webViewUrl;
  final String appBarTitle;

  late final webViewController =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..clearLocalStorage()
        ..loadRequest(webViewUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: SafeArea(child: WebViewWidget(controller: webViewController)),
    );
  }
}
