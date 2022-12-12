import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static final MaterialColor primarySwatch =
      MaterialColor( 0xffFAFAFA, <int, Color>{
    50: Color(0xffFAFAFA),
    100: Color(0xffF5F5F5),
    200: Color(0xffEEEEEE),
    300: Color(0xffE0E0E0),
    400: Color(0xffBDBDBD),
    500: Color(0xff9E9E9E),
    600: Color(0xff757575),
    700: Color(0xff616161),
    800: Color(0xff424242),
    900: Color(0xff212121),
  });

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(

      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      primarySwatch: primarySwatch,
      primaryColor: isDarkTheme ?Color( 0xff121212): Colors.white,

      backgroundColor: isDarkTheme ? Colors.red : Color(0xffF1F5FB),

      indicatorColor:  isDarkTheme ? Color( 0xff121212) : Colors.white,
      //buttonColor:isDarkTheme ? Color( 0xff121212) : Colors.white,

      hintColor: isDarkTheme ? Colors.white : Color( 0xff121212),

      highlightColor: Color(0xFFFF8F00),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      focusColor: Color(0xFFFF8F00),
      disabledColor: Colors.grey,
      //textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xff121212) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      scaffoldBackgroundColor: isDarkTheme ? Color( 0xff121212) : Colors.white,
      textTheme: TextTheme(

        button: GoogleFonts.notoSansArabic(
            // textStyle: TextStyle(color: Color(0xFF666666),
            ),
        headline3: GoogleFonts.notoSansArabic(
          textStyle:
          TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
        ),
        headline6: GoogleFonts.notoSansArabic(
          textStyle:
              TextStyle( color: Colors.white, fontWeight: FontWeight.bold),
        ),headline5: GoogleFonts.notoSansArabic(
          textStyle:
              TextStyle(fontSize: 14.0 ,color: Colors.white, fontWeight: FontWeight.bold),
        ),
        headline4: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
              fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle1: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.grey ,
          ),
        ),
        subtitle2: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
        bodyText1: GoogleFonts.notoSansArabic(
            textStyle: TextStyle(
          fontSize: 13.0,
          color: Colors.white,
        )),
      ),

      inputDecorationTheme: InputDecorationTheme(

        suffixStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(
          fontSize: 10.0,
        ),
        iconColor: Color(0xFFFF9800),
        suffixIconColor: Colors.white,
        prefixIconColor: Color(0xFFFF9800),
        fillColor: Color(0xFF5a565f),
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: GoogleFonts.notoSansArabic(
            color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
        filled: true,
        enabledBorder: OutlineInputBorder(

          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD3D3D3)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFfd7e14)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),



      appBarTheme: AppBarTheme(

        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black54,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Color(0xFFFFFFFF),
        elevation: 1.0,
        centerTitle: true,
      ),
    );
  }
}
