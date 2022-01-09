import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/HomeApp/EventFolder/SectionOne.dart';
import 'package:systemevents/HomeApp/HomePage.dart';
import 'package:systemevents/HomeApp/menu/EventMenu.dart';
import 'package:systemevents/HomeApp/settings/About.dart';
import 'package:systemevents/HomeApp/settings/ProfileView.dart';
import 'package:systemevents/HomeApp/settings/ResetPassword/CreateNewPasswordView.dart';
import 'package:systemevents/HomeApp/settings/ThemeApp.dart';
import 'package:systemevents/provider/Auth.dart';
import 'package:systemevents/provider/EventProvider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'loginAndRegister/loginUI.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future  main() async{
  final MaterialColor primarySwatch = MaterialColor(0xff5a8f62, <int, Color>{
    50: Color(0xffE8F5E9),
    100: Color(0xffC8E6C9),
    200: Color(0xffA5D6A7),
    300: Color(0xff81C784),
    400: Color(0xff66BB6A),
    500: Color(0xff4CAF50),
    600: Color(0xff43A047),
    700: Color(0xff388E3C),
    800: Color(0xff2E7D32),
    900: Color(0xff1B5E20),
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs= await Singleton.getPrefInstace();
  String token = prefs.getString("api_token");
  print(token);

  if (defaultTargetPlatform == TargetPlatform.android) {

    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;

  }




  runApp( MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(create:(context)=>EventProvider(),),
            ChangeNotifierProvider<UserAuthProvider>(create:(context)=>UserAuthProvider(),),
          ],
         child:  MaterialApp(
           localizationsDelegates: const [
             GlobalMaterialLocalizations.delegate,
             GlobalWidgetsLocalizations.delegate,
             GlobalCupertinoLocalizations.delegate,
           ],
           supportedLocales: [
             Locale('ar', ''), // arabic, no country code

           ],
           theme: ThemeData(
             iconTheme: IconThemeData(color: Color(0xff74767f)),
             backgroundColor: Color(0xFFFFFFFF),
             shadowColor: Color(0xFF242b3b),
             hintColor: Color(0xFF74767f),
             inputDecorationTheme: InputDecorationTheme(

               fillColor: Color(0xFFFFFFFF),
               isDense: true,
               contentPadding: EdgeInsets.all(16),
               labelStyle: GoogleFonts.notoSansArabic(
                   color: Color(0xFF242b3b),fontWeight: FontWeight.bold
               ) ,
               filled: true,
               enabledBorder: OutlineInputBorder(
                 borderSide: BorderSide(color:Colors.blueGrey),
                 borderRadius: BorderRadius.circular(10),
               ),
               disabledBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Color(0xFFD3D3D3)),
                 borderRadius: BorderRadius.circular(10),
               ),
               focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide(color: Color(0xFFD3D3D3)),
                 borderRadius: BorderRadius.circular(10),
               ),
             ),
             textTheme: TextTheme(
               button: GoogleFonts.notoSansArabic(
                // textStyle: TextStyle(color: Color(0xFF666666),
                 ),
                 headline6: GoogleFonts.notoSansArabic(
                    textStyle: TextStyle(color: Color(0xFF666666), fontWeight: FontWeight.bold),
                 ),
                 headline4:
                 GoogleFonts.notoSansArabic(
                   textStyle: TextStyle(color: Color(0xFF666666), fontWeight: FontWeight.bold),
                 ),
                 subtitle1: GoogleFonts.notoSansArabic(
                 textStyle: TextStyle(
                       color: Colors.grey.shade600,
                   ),
             ),
               bodyText1: GoogleFonts.notoSansArabic(
                   textStyle: TextStyle(color: Color(0xFF666666),)
               )
           ),
               scaffoldBackgroundColor:Colors.white,

             appBarTheme: AppBarTheme(
               titleTextStyle: GoogleFonts.notoSansArabic(
                 textStyle: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold,fontSize: 18),
               ),
                 iconTheme: IconThemeData(color: Colors.white) ,
               color: Color(0xFF5a8f62),
               shadowColor: Color(0xFF5a8f62),
               elevation: 1.0,
               centerTitle: true,
             ),
             primarySwatch: primarySwatch,
           ),
           debugShowCheckedModeBanner: false,
           // title: 'Flutter Demo',
           //  theme: ThemeData(
           //    primarySwatch: Colors.blue,
           //  ),
           home: token!=null ?HomePage(): LoginUi(),
           routes: {
             'About':(context)=>About(),
             'ProfilePage':(context)=>ProfilePage(),
             'ResetPage':(context)=>CreateNewPasswordView(),
             'ThemeApp':(context)=>ThemeApp(),
             'EventSectionOne':(context)=>EventSectionOne(),
             'eventList':(context)=>EventsMenu(),

             },
          ),
        ) ,
      );}


