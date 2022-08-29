import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/singleton/singleton.dart';

 //
// class ProviderData extends ChangeNotifier{
//
//   ThemeData _themeData=darkMode? ThemeData.dark():ThemeData.light();
//
//   ThemeData get getThemeData => _themeData;
//
//   set setThemeData(ThemeData value) {
//     _themeData = value;
//     notifyListeners();
//   }
// }

class DarkThemePreference {
     String THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await Singleton.getPrefInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await Singleton.getPrefInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}