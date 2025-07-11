import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/Responses/responses_screen.dart';
import 'package:shahed/modules/home/event_screens/main_section.dart';
import 'package:shahed/modules/home/home.dart';
import 'package:shahed/modules/home/informauthorities/inform.dart';
import 'package:shahed/modules/home/mainpage.dart';
import 'package:shahed/modules/home/menu/menu_screen.dart';
import 'package:shahed/modules/home/settings_screens/app_settings.dart';
import 'package:shahed/modules/home/settings_screens/about_screen.dart';
import 'package:shahed/modules/home/settings_screens/profile_view.dart';
import 'package:shahed/modules/home/settings_screens/reset_password/CreateNewPasswordView.dart';
import 'package:shahed/modules/home/tracking/BrowserMap.dart';
import 'package:shahed/provider/auth_provider.dart';
import 'package:shahed/provider/counter_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/provider/language.dart';
import 'package:shahed/provider/navigation_provider.dart';
import 'package:shahed/provider/style_data.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/theme/theme.dart';
import 'package:shahed/widgets/customDirectionality.dart';
import 'modules/home/event_screens/SuccessPage.dart';
import 'modules/authentications/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shahed/notification/notification.dart' as notif;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'modules/home/tracking/missions_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
@pragma('vm:entry-point')
void callbackDispatcher() {
  try {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case "fetchBackground":
          // loc.Location currentLocation=loc.Location();
        await Hive.initFlutter();
                    Box box = await SharedClass.getBox();

                    final storage = await SharedClass.getStorage();
                    String? value;
                    // if(await storage.containsKey(key: 'token'))
          value   = await storage.read(
              key: "token", aOptions: SharedClass.getAndroidOptions());
                    Map? data;
          bg.BackgroundGeolocation.getCurrentPosition(
              persist: false,     // <-- do not persist this location
              desiredAccuracy: 0, // <-- desire best possible accuracy
              timeout: 30000,     // <-- wait 30s before giving up.
              samples: 3          // <-- sample 3 location before selecting best.
          ).then((bg.Location userLocation)  {
            if(box.containsKey('user_id')){
            data = {
            'user_id': box.get('user_id').toString(),
            'lat': userLocation.coords.latitude.toString(),
            'lng': userLocation.coords.longitude.toString(),
            };
            } }).catchError((error) {
            print('[getCurrentPosition] ERROR: $error');
          });
            final response = await http.post(
            Uri.parse('${SharedClass.apiPath}/updateUnit'),
            body: jsonEncode(data),
            headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $value',
            'content-type': 'application/json',
            });
            print("response.statusCode :${ response.body}");
            if (response.statusCode == 200) {
            json.decode(response.body);
            notif.Notification notification = new notif.Notification();
            notification.showNotificationWithoutSound("تم ارسال موقع الوحدة للخادم" );

            }

          //await currentLocation.enableBackgroundMode(enable: true);
        //  var userLocation=await currentLocation.getLocation();
          // Position userLocation = await Geolocator.getCurrentPosition(
          //     desiredAccuracy: LocationAccuracy.high);

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
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()
    //      .createNotificationChannel(channel);
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(channel);
    }
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          !.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
      );
    }
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final directory = await path.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
   // Hive.registerAdapter(TrackingAdapter());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    String? token;
       await SharedClass.getStorage().then((storage) async{
           token=await storage.read(
               key: "api_token", aOptions: SharedClass.getAndroidOptions());
          if(token==null)
             token='';
      });




    final box = await SharedClass.getBox();

    if (box.containsKey('language')) {
      language = box.get('language');
    } else {
      box.put('language', 'AR');
      language = box.get('language');
    }
    //darkMode=pref.getBool('darkMode');
    SharedData.getGlobalLang().setLanguage = language;

    if(box.isOpen);
       box.put('version_number', 0);

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
    // await SentryFlutter.init(
    //         (options) {
    //       options.dsn = 'https://92119abba7a54244918bed279f872012@o4504264870461440.ingest.sentry.io/4504264877211648';
    //     },
    //     // Init your App.
    //     appRunner:() =>
  print('the token $token');
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
        ),
        ChangeNotifierProvider<Language>(
          create: (context) => Language(),
        ),
        ChangeNotifierProvider<CounterProvider>(
          create: (context) => CounterProvider(),
        ),
      ],
        child:   ShahedApp(token, language)
    ),
  //  )
  );
  //  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  } catch (e) {
    print(e);
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ShahedApp extends StatefulWidget {
  String ? token;
  String language;

  ShahedApp(this.token, this.language);

  static void restartApp(BuildContext context) {

    context.findAncestorStateOfType<_ShahedAppState>()!.restartApp();
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
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            onGenerateRoute: (viewName) {
              if (viewName.name == 'Missions')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => Missions());
              else if  (viewName.name == 'browserMap')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => BrowserMap(state: 0,));
                else if (viewName.name == 'About')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => About());
              else  if (viewName.name == 'Inform')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => InformEntity());
              else  if (viewName.name == 'Home')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage());
              else  if (viewName.name == 'ProfilePage')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => ProfilePage());
              else  if (viewName.name == 'ResetPage')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => CreateNewPasswordView());
              else  if (viewName.name == 'settings')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => AppSettings());
              else  if (viewName.name == 'EventSectionOne')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => EventSectionOne());
              else  if (viewName.name == 'eventList')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => EventsMenu());
              else  if (viewName.name == 'response')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => ResponsePage());
              else  if (viewName.name == 'successPage')
                  return PageRouteBuilder(pageBuilder: (_, __, ___) => SuccessPage());
             else
              return null;
            },
            // themeMode: Provider.of<ThemeProvider>(context).themeMode,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            // darkTheme: MyThemes.darkTheme,

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              language == "AR" ? Locale("ar") : Locale("en", "US"),
              // arabic, no country code
            ],

            //theme:,
            debugShowCheckedModeBanner: false,
            home: KeyedSubtree(
                key: key,
                child: customDirectionality(
                    child: widget.token != '' ? MainPage() : LoginUi())),

            // routes: {
            //   'About': (context) => About(),
            //   'Inform': (context) => InformEntity(),
            //   'Home': (context) => HomePage(),
            //   'ProfilePage': (context) => ProfilePage(),
            //   'ResetPage': (context) => CreateNewPasswordView(),
            //   'settings': (context) => AppSettings(),
            //   'EventSectionOne': (context) => EventSectionOne(),
            //   'eventList': (context) => EventsMenu(),
            //   'browserMap': (context) => BrowserMap(state: 0,),
            //   'response': (context) => ResponsePage(),// notifications single notification page
            //   'successPage': (context) => SuccessPage(),
            //   'Missions': (context) => Missions(),// list of missions
            //
            // },
          );
        },
      ),
    );
  }
}
