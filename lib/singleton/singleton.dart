import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/provider/language.dart';

class Singleton {
  Singleton._();

  static SharedPreferences _pref;
  static FlutterSecureStorage _storage;
  static String apiPath="http://192.168.1.3:8000/api";
  static Language _language;

  static Future<SharedPreferences> getPrefInstance() async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }
    return _pref;
  }
  static Language getLanguage()  {
    if (_language == null) {
      _language = Language();
    }
    return _language;
  }
  static  Future<FlutterSecureStorage>  getStorage() async {
    if (_storage == null) {
      _storage = FlutterSecureStorage();
    }
    return _storage;
  }
 static AndroidOptions  getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

}