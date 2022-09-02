import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

//  this old theme for app
//
// class CustomTheme{
//  static final MaterialColor primarySwatch = MaterialColor(0xff5a8f62, <int, Color>{
//     50: Color(0xffE8F5E9),
//     100: Color(0xffC8E6C9),
//     200: Color(0xffA5D6A7),
//     300: Color(0xff81C784),
//     400: Color(0xff66BB6A),
//     500: Color(0xff4CAF50),
//     600: Color(0xff43A047),
//     700: Color(0xff388E3C),
//     800: Color(0xff2E7D32),
//     900: Color(0xff1B5E20),
//   });
//
//  static ThemeData myTheme(){
//     return ThemeData(
//
//       iconTheme: IconThemeData(color: Color(0xff74767f)),
//       backgroundColor: Color(0xFFFFFFFF),
//       shadowColor: Color(0xFF242b3b),
//       hintColor: Color(0xFF74767f),
//       inputDecorationTheme: InputDecorationTheme(
//         fillColor: Color(0xFFFFFFFF),
//         isDense: true,
//         contentPadding: EdgeInsets.all(16),
//         labelStyle: GoogleFonts.notoSansArabic(
//             color: Color(0xFF242b3b), fontWeight: FontWeight.bold),
//         filled: true,
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blueGrey),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFFD3D3D3)),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFFD3D3D3)),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       textTheme: TextTheme(
//           button: GoogleFonts.notoSansArabic(
//             // textStyle: TextStyle(color: Color(0xFF666666),
//           ),
//           headline6: GoogleFonts.notoSansArabic(
//             textStyle: TextStyle(
//                 color: Color(0xFF666666), fontWeight: FontWeight.bold),
//           ),
//           headline4: GoogleFonts.notoSansArabic(
//             textStyle: TextStyle(
//                 color: Color(0xFF666666), fontWeight: FontWeight.bold),
//           ),
//           subtitle1: GoogleFonts.notoSansArabic(
//             textStyle: TextStyle(
//               color: Colors.grey.shade600,
//             ),
//           ),
//           bodyText1: GoogleFonts.notoSansArabic(
//               textStyle: TextStyle(
//                 color: Color(0xFF666666),
//               ))),
//       scaffoldBackgroundColor: Colors.white,
//       appBarTheme: AppBarTheme(
//         titleTextStyle: GoogleFonts.notoSansArabic(
//           textStyle: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 18),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         color: Color(0xFF5a8f62),
//         shadowColor: Color(0xFF5a8f62),
//         elevation: 1.0,
//         centerTitle: true,
//       ),
//       primarySwatch: primarySwatch,
//     );
//   }
// }


// this new theme for app


class Styles {
   static final MaterialColor primarySwatch = MaterialColor(0xff5a8f62, <int, Color>{
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

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(

      primarySwatch: primarySwatch,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,

      backgroundColor: isDarkTheme ? Colors.red : Color(0xffF1F5FB),

      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),

      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      scaffoldBackgroundColor:isDarkTheme ? Colors.grey : Colors.white,
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),

        shadowColor: Color(0xFF5a8f62),
        elevation: 1.0,
        centerTitle: true,
      ),
    );

  }
}