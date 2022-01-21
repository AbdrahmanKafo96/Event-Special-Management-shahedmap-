import 'dart:async';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'CreateNewPasswordView.dart';

class CheckEmailView extends StatefulWidget {
  //const CheckEmailView({Key? key}) : super(key: key);
  @override
  State<CheckEmailView> createState() => _CheckEmailViewState();
}

class _CheckEmailViewState extends State<CheckEmailView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'رجوع',
            style: TextStyle(color: Colors.white),
          ),
          // leadingWidth: 25,
          leading: IconButton(
            icon: Icon(Icons.arrow_back ,color: Colors.white,),
            onPressed: () {},
          ),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Icon(Icons.help_outline ,color: Colors.white,),
            // )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        size: 100,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'تحقق من البريد الالكتروني',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'لقد أرسلنا تعليمات استعادة كلمة المرور إلى بريدك الإلكتروني.',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        //navigate to create new password view
                        //  Util.routeToWidget(context, CreateNewPasswordView());
                        //   if (Platform.isAndroid) {
                        //     AndroidIntent intent = AndroidIntent(
                        //       action: 'android.intent.action.MAIN',
                        //       category: 'android.intent.category.APP_EMAIL',
                        //     );
                        //     intent.launch().catchError((e) {
                        //
                        //     });
                        //   } else if (Platform.isIOS) {
                        //     launch("message://").catchError((e){
                        //
                        //     });
                        //   }
                        //     WebView(
                        //     initialUrl: 'https://flutter.dev',
                        //     javascriptMode: JavascriptMode.unrestricted,
                        //     onWebViewCreated: (WebViewController webViewController) {
                        //       _controller.complete(webViewController);
                        //     },
                        //     onProgress: (int progress) {
                        //       print("WebView is loading (progress : $progress%)");
                        //     },
                        //     javascriptChannels: <JavascriptChannel>{
                        //       _toasterJavascriptChannel(context),
                        //     },
                        //     navigationDelegate: (NavigationRequest request) {
                        //       if (request.url.startsWith('https://www.youtube.com/')) {
                        //         print('blocking navigation to $request}');
                        //         return NavigationDecision.prevent;
                        //       }
                        //       print('allowing navigation to $request');
                        //       return NavigationDecision.navigate;
                        //     },
                        //     onPageStarted: (String url) {
                        //       print('Page started loading: $url');
                        //     },
                        //     onPageFinished: (String url) {
                        //       print('Page finished loading: $url');
                        //     },
                        //     gestureNavigationEnabled: true,
                        //   );
                        //   WebView(
                        //     initialUrl: 'https://flutter.dev',
                        //   );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewClass()));
                      },
                      child: Text(
                        'افتح تطبيق البريد الالكتروني',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'تخطي ، سيتم التأكيد لاحقًا',
                      style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('لم تستلم البريد الإلكتروني؟ تحقق من البريد العشوائي(spam)الخاص بك'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('or'),
                      TextButton(
                        onPressed: (){

                        },
                        child: Text('جرب بريد إللكتروني اخر'),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
class WebViewClass extends StatefulWidget {
  @override
  _WebViewClassState createState() => _WebViewClassState();
}

class _WebViewClassState extends State<WebViewClass> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WebView'),
        ),
        // body: WebView(
        //   initialUrl: 'https://accounts.google.com/',
        //   onWebViewCreated: (WebViewController webViewController) {
        //     _controller.complete(webViewController);
        //   },
        // ),
        body:WebView(
          initialUrl: 'https://accounts.google.com/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
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
        )
    );
  }
}