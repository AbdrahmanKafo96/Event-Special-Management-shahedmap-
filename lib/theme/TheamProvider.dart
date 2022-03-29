import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final MaterialColor primarySwatch = MaterialColor(0xff5a8f62, <int, Color>{
    50: Color(0xffECEFF1),
    100: Color(0xffCFD8DC),
    200: Color(0xffB0BEC5),
    300: Color(0xff90A4AE),
    400: Color(0xff78909C),
    500: Color(0xff607D8B),
    600: Color(0xff546E7A),
    700: Color(0xff455A64),
    800: Color(0xff37474F),
    900: Color(0xff263238),
  });
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.grey.shade800,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Color(0xff74767f)),
    backgroundColor: Color(0xFFFFFFFF),
    shadowColor: Color(0xFF242b3b),
    hintColor: Color(0xFF74767f),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFFFFFFFF),
      isDense: true,
      contentPadding: EdgeInsets.all(16),
      labelStyle: GoogleFonts.notoSansArabic(
          color: Color(0xFF242b3b), fontWeight: FontWeight.bold),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey),
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
          textStyle: TextStyle(
              color: Color(0xFF666666), fontWeight: FontWeight.bold),
        ),
        headline4: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
              color: Color(0xFF666666), fontWeight: FontWeight.bold),
        ),
        subtitle1: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        bodyText1: GoogleFonts.notoSansArabic(
            textStyle: TextStyle(
              color: Color(0xFF666666),
            ))),

    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.notoSansArabic(
        textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      color: Color(0xFF424242),
      shadowColor: Color(0xFF616161),
      elevation: 1.0,
      centerTitle: true,
    ),
    primarySwatch: primarySwatch,
    //iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
  );
}