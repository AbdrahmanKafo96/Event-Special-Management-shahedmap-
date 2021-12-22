import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  TextEditingController controller = TextEditingController();

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  var urlString = "https://google.com";

  launchUrl() {
    setState(() {
      urlString = controller.text;
      flutterWebviewPlugin.reloadUrl(urlString);
    });
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: urlString,
      withZoom: false,
      withLocalStorage: true,



    );
  }
  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    controller.clear();
    super.dispose();
  }
}
