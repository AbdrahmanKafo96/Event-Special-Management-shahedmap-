import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class  CustomWebView extends StatefulWidget {

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  TextEditingController controller = TextEditingController();



  var urlString = "http://192.168.1.3:8000/auth/login";


  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height ,
          child:  WebView(
            zoomEnabled:false ,
            initialUrl: urlString,
          ),
        ),
      ),
    );
  }

}
