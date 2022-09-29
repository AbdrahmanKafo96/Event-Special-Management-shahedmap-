import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/unit.dart';
import 'package:shahed/modules/home/Responses/responses_screen.dart';
import 'package:shahed/modules/home/event_screens/main_section.dart';
import 'package:shahed/modules/home/home.dart';
import 'package:shahed/modules/home/informauthorities/inform.dart';
import 'package:shahed/modules/home/mainpage.dart';
import 'package:shahed/modules/home/menu/menu_screen.dart';
import 'package:shahed/modules/home/search.dart';
import 'package:shahed/modules/home/settings_screens/app_settings.dart';
import 'package:shahed/modules/home/settings_screens/about_screen.dart';
import 'package:shahed/modules/home/settings_screens/profile_view.dart';
import 'package:shahed/modules/home/settings_screens/reset_password/CreateNewPasswordView.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/provider/language.dart';
import 'package:shahed/provider/navigation_provider.dart';
import 'package:shahed/provider/style_data.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/theme/theme.dart';
import 'package:shahed/web_browser/webView.dart';
import 'modules/home/event_screens/SuccessPage.dart';
import 'modules/authentications/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shahed/notification/notification.dart' as notif;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

callbackDispatcher() {
  try {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case "fetchBackground":
          Position userLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          await Hive.initFlutter();
          Box box = await Singleton.getBox();

          final storage = await Singleton.getStorage();
          String value = await storage.read(
              key: "token", aOptions: Singleton.getAndroidOptions());

          Map data = {
            'user_id': box.get('user_id').toString(),
            'lat': userLocation.latitude.toString(),
            'lng': userLocation.longitude.toString(),
          };
          final response = await http.post(
              Uri.parse('${Singleton.apiPath}/updateUnit'),
              body: jsonEncode(data),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $value',
                'content-type': 'application/json',
              });

          if (response.statusCode == 200) {
            json.decode(response.body);
            notif.Notification notification = new notif.Notification();
            notification.showNotificationWithoutSound("تم إرسال موقع الوحدة");
          }
          break;
      }
      return Future.value(true);
    });
  } catch (e) {
    print(e);
  }
}

String language = "AR";
//bool  darkMode=false;

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final directory = await path.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TrackingAdapter());

    String token = null;
    final storage = await Singleton.getStorage();

    token = await storage.read(
        key: "api_token", aOptions: Singleton.getAndroidOptions());

    final box = await Singleton.getBox();

    language = box.get('language');
    //darkMode=pref.getBool('darkMode');

    if (box.get('version_number') == null) box.put('version_number', 0);

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
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
        ChangeNotifierProvider<NavigationProvider>(
          create: (context) => NavigationProvider(),
        ),
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (context) => DarkThemeProvider(),
        ),ChangeNotifierProvider<Language>(
          create: (context) => Language(),
        ),
      ], child: ShahedApp(token)),
    );
  } catch (e) {
    print(e);
  }
}

class ShahedApp extends StatefulWidget {
  String token;

  ShahedApp(this.token);

  @override
  State<ShahedApp> createState() => _ShahedAppState();
}

class _ShahedAppState extends State<ShahedApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() {
    themeChangeProvider.darkThemePreference.getTheme().then((value) {
      setState(() {
        themeChangeProvider.darkTheme = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final theme=Provider.of<ProviderData>(context);
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            // themeMode: Provider.of<ThemeProvider>(context).themeMode,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            // darkTheme: MyThemes.darkTheme,

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
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: widget.token != null ? MainPage() : LoginUi(),
            ),
            routes: {
              'About': (context) => About(),
              'Inform': (context) => InformEntity(),
              'serc': (context) => SearchPlacesScreen(),
              'Home': (context) => HomePage(),
              'ProfilePage': (context) => ProfilePage(),
              'ResetPage': (context) => CreateNewPasswordView(),
              'settings': (context) => AppSettings(),
              'EventSectionOne': (context) => EventSectionOne(),
              'eventList': (context) => EventsMenu(),
              'CustomWebView': (context) => CustomWebView(),
              'response': (context) => ResponsePage(),
              'successPage': (context) => SuccessPage(),
            },
          );
        },
      ),
    );
  }
}
