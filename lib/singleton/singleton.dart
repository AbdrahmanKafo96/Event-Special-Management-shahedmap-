import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:systemevents/provider/language.dart';

class Singleton {
  Singleton._();


  static FlutterSecureStorage _storage;
  static String apiPath="http://ets.ly/api";
  static String routePath="http://ets.ly";
  static Language _language;
  static Box _boxUserData ,_trackingBox;

  static Future<Box> getBox() async {
    if (_boxUserData == null) {
      _boxUserData = await  Hive.openBox("userData") ;
    }

    return _boxUserData;
  }
  static Future<Box> getTrackingBox() async {
    if (_trackingBox == null) {
      _trackingBox = await  Hive.openBox("Tracking") ;
    }
    return _trackingBox;
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