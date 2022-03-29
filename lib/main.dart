import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/modules/home/Responses/responses_screen.dart';
import 'package:systemevents/modules/home/event_screens/main_section.dart';
import 'package:systemevents/modules/home/home.dart';
import 'package:systemevents/modules/home/menu/menu_screen.dart';
import 'package:systemevents/modules/home/settings_screens/ResetPassword/CreateNewPasswordView.dart';
import 'package:systemevents/modules/home/settings_screens/ThemeApp.dart';
import 'package:systemevents/modules/home/settings_screens/about_screen.dart';
import 'package:systemevents/modules/home/settings_screens/profile_view.dart';

import 'package:systemevents/provider/auth_provider.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/theme/TheamProvider.dart';
import 'package:systemevents/theme/theam.dart';
import 'package:systemevents/web_browser/webView.dart';
import 'modules/login/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:systemevents/notification/notification.dart' as notif;
import 'dart:convert'  as convert;
import 'package:http/http.dart' as http;

callbackDispatcher() {
  try {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case "fetchBackground":
          Position userLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          print(userLocation);
          // print(userLocation.longitude);
          SharedPreferences prefs = await Singleton.getPrefInstance();
          final storage = await Singleton.getStorage()  ;
          String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
          Map data = {
            'user_id': prefs.getInt('user_id').toString(),
            'lat': userLocation.latitude.toString(),
            'lng': userLocation.longitude.toString(),
          };
          final response = await http
              .post(Uri.parse('${Singleton.apiPath}/updateUnit' ),  body:jsonEncode(data),headers: {
              'Accept':'application/json',
              'Authorization' : 'Bearer $value',
              'content-type': 'application/json',}
              );

          if (response.statusCode == 200) {
            var parsed = json.decode(response.body);
            notif.Notification notification = new notif.Notification();
            notification.showNotificationWithoutSound(userLocation);
            // if(parsed['message']=='success'){
            //    // return true;
            // } else {
            //     //return false;
            // }
          }
          break;
      }
      return Future.value(true);
    });
  } catch (e) {
    print(e);
  }
}

Future main() async {
    try{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      final storage = await Singleton.getStorage()  ;
      String token = await storage.read(key: "api_token" ,aOptions: Singleton.getAndroidOptions());
      final pref= await Singleton.getPrefInstance();
      if(pref.getInt('version_number')==null)
        pref.setInt('version_number', 0);


      if (defaultTargetPlatform == TargetPlatform.android) {
        AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
      }
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(
              create: (context) => EventProvider(),
            ),
            ChangeNotifierProvider<UserAuthProvider>(
              create: (context) => UserAuthProvider(),
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider(),
            ),
          ],
          child:MyApp(token)
        ),
      );
    }catch (e) {
      print(e);
    }


}
class MyApp extends StatefulWidget {
  String token;
  MyApp(this.token);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode:Provider.of<ThemeProvider>(context).themeMode,
      theme:  CustomTheme.myTheme(),
      darkTheme: MyThemes.darkTheme,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', ''), // arabic, no country code
      ],
      //theme:,
      debugShowCheckedModeBanner: false,
      home: widget.token != null ? HomePage() : LoginUi(),
      routes: {
        'About': (context) => About(),
        'ProfilePage': (context) => ProfilePage(),
        'ResetPage': (context) => CreateNewPasswordView(),
        'ThemeApp': (context) => ThemeApp(),
        'EventSectionOne': (context) => EventSectionOne(),
        'eventList': (context) => EventsMenu(),
        'CustomWebView': (context) => CustomWebView(),
        'response': (context) => ResponsePage(),
      },
    );
  }


}
