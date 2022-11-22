import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/unit.dart';
import 'package:shahed/modules/home/Responses/responses_screen.dart';
import 'package:shahed/modules/home/event_screens/main_section.dart';
import 'package:shahed/modules/home/home.dart';
import 'package:shahed/modules/home/important.dart';
import 'package:shahed/modules/home/informauthorities/inform.dart';
import 'package:shahed/modules/home/mainpage.dart';
import 'package:shahed/modules/home/menu/menu_screen.dart';
import 'package:shahed/modules/home/search.dart';
import 'package:shahed/modules/home/settings_screens/app_settings.dart';
import 'package:shahed/modules/home/settings_screens/about_screen.dart';
import 'package:shahed/modules/home/settings_screens/profile_view.dart';
import 'package:shahed/modules/home/settings_screens/reset_password/CreateNewPasswordView.dart';
import 'package:shahed/modules/home/tracking/mission_track.dart';
import 'package:shahed/modules/home/tracking/tracking_user.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/provider/language.dart';
import 'package:shahed/provider/navigation_provider.dart';
import 'package:shahed/provider/style_data.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/theme/theme.dart';
import 'package:shahed/web_browser/webView.dart';
import 'package:shahed/widgets/customDirectionality.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'modules/home/tracking/missions_list.dart';
import 'modules/home/tracking/unit_tracking.dart';

@pragma('vm:entry-point')
callbackDispatcher() {
  try {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case "fetchBackground":
          Position userLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          await Hive.initFlutter();
          Box box = await SharedClass.getBox();

          final storage = await SharedClass.getStorage();
          String value = await storage.read(
              key: "token", aOptions: SharedClass.getAndroidOptions());

          Map data = {
            'user_id': box.get('user_id').toString(),
            'lat': userLocation.latitude.toString(),
            'lng': userLocation.longitude.toString(),
          };
          final response = await http.post(
              Uri.parse('${SharedClass.apiPath}/updateUnit'),
              body: jsonEncode(data),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $value',
                'content-type': 'application/json',
              });

          if (response.statusCode == 200) {
            json.decode(response.body);
            notif.Notification notification = new notif.Notification();
            notification.showNotificationWithoutSound("تم إرسال موقع الوحدة" );
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
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}
Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
         .createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final directory = await path.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(TrackingAdapter());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    String token = null;
    final storage = await SharedClass.getStorage();

    token = await storage.read(
        key: "api_token", aOptions: SharedClass.getAndroidOptions());

    final box = await SharedClass.getBox();
    if (box.containsKey('language')) {
      language = box.get('language');
    } else {
      box.put('language', 'AR');
      language = box.get('language');
    }
    //darkMode=pref.getBool('darkMode');
    SharedData.getGlobalLang().setLanguage = language;
    if (box.get('version_number') == null) box.put('version_number', 0);

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }

    runApp(
      MultiProvider(providers: [
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
        ),
        ChangeNotifierProvider<Language>(
          create: (context) => Language(),
        ),
      ], child: ShahedApp(token, language)),
    );
  } catch (e) {
    print(e);
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ShahedApp extends StatefulWidget {
  String token;
  String language;

  ShahedApp(this.token, this.language);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_ShahedAppState>().restartApp();
  }

  @override
  State<ShahedApp> createState() => _ShahedAppState();
}

class _ShahedAppState extends State<ShahedApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

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
              language == "AR" ? Locale('ar', '') : Locale("en", "US"),
              // arabic, no country code
            ],

            //theme:,
            debugShowCheckedModeBanner: false,
            home: KeyedSubtree(
                key: key,
                child: customDirectionality(
                    child: widget.token != null ? MainPage() : LoginUi())),

            routes: {
              'About': (context) => About(),
              'important': (context) => Important(),
              'MissionTracking': (context) => MissionTracking(),
              'Inform': (context) => InformEntity(),
              'serc': (context) => SearchPlacesScreen(),
              'Home': (context) => HomePage(),
              'ProfilePage': (context) => ProfilePage(),
              'ResetPage': (context) => CreateNewPasswordView(),
              'settings': (context) => AppSettings(),
              'EventSectionOne': (context) => EventSectionOne(),
              'eventList': (context) => EventsMenu(),
              'unitTracking': (context) => UserTracking(),
              'response': (context) => ResponsePage(),
              'successPage': (context) => SuccessPage(),
              'Missions': (context) => Missions(),
            },
          );
        },
      ),
    );
  }
}
