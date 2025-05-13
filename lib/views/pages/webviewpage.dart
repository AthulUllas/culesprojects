import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(appBarTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                final params = ShareParams(uri: webViewUrl);
                SharePlus.instance.share(params);
              },
              icon: Icon(Icons.share),
            ),
          ),
        ],
      ),
      body: SafeArea(child: WebViewWidget(controller: webViewController)),
    );
  }
}
