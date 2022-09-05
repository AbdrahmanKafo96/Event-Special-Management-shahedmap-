 import 'dart:async';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class  CustomWebView extends StatefulWidget {

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  TextEditingController controller = TextEditingController();



 // var urlString = "http://192.168.1.3:8000/auth/login";
  Completer<WebViewController> _controller =
  Completer<WebViewController>();

  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // return  Expanded(
    //   child: SingleChildScrollView(
    //     child: Container(
    //       height: MediaQuery.of(context).size.height ,
    //       child:  WebView(
    //         zoomEnabled:false ,
    //         initialUrl: urlString,
    //         javascriptMode: JavascriptMode.unrestricted,
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00695C) ,
                  Color(0xFF4DB6AC),
                ],
              )),
        ),
      ),
      body: WebView(

        initialUrl: "https://www.ets.ly/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          // if (request.url.startsWith('http://192.168.1.3:8000/')) {
          //   print('blocking navigation to $request}');
           // return NavigationDecision.prevent;
          //}
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),



  ),
    );
}

JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        // ignore: deprecated_member_use
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(content: Text(message.message)),
        // );
      });
}

Widget favoriteButton() {
  return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context,
          AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              final String url = (await controller.data .currentUrl()) ;
              // ignore: deprecated_member_use
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Favorited $url')),
              );
            },
            child: const Icon(Icons.favorite),
          );
        }
        return Container();
      });
  }

}
