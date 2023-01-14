import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shahed/provider/language.dart';
import 'package:weather/weather.dart' as wea;
import 'package:location/location.dart' as loc;
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
// as bg;
class SharedClass {
  SharedClass._();

  static FlutterSecureStorage? _storage;
  static String apiPath = "http://ets.ly/api";
  static String routePath = "http://ets.ly";
  static const String mapApiKey = "AIzaSyCxMAiyFG-l2DUifjrksWErZFk_gZ8mTEk";
  static const String weatherApiKey = "fe5ab7fcf47cd01b406b3d7faa519b21";
  static Language? _language;
  static Box? _boxUserData ;
  static wea.WeatherFactory? _wf;
  static loc.Location? _location;
  static bool _state=false ;

  static bool  getBGState({bool? state}) {
     // if(state==true || state==false){
     //   _state=state! ;
     // }
    return _state?? state! ;
  }
  static wea.WeatherFactory getWeatherFactory() {
    if (_wf == null) {
      _wf = wea.WeatherFactory(SharedClass.weatherApiKey.toString(),
          language: wea.Language.ENGLISH);
    }
    return _wf??wea.WeatherFactory(SharedClass.weatherApiKey.toString(),
        language: wea.Language.ENGLISH);
  }

  static Future<Box> getBox() async {
    // if (_boxUserData == null) {
    //   _boxUserData = await Hive.openBox("userData");
    // }
    return _boxUserData ?? await Hive.openBox("userData");
  }
  static loc.Location  getLocationObj() {
    // if (_location == null) {
    //   _location = loc.Location();
    // }
    return _location?? loc.Location();
  }

     closeBox() async {
    if (_boxUserData != null) {
      _boxUserData!.close().then((value) {
        print("Tracking now is close");
      });
    }
  }

  // static Future<Box> getTrackingBox() async {
  //   if (_trackingBox == null) {
  //     _trackingBox = await Hive.openBox("Tracking");
  //   }
  //   return _trackingBox;
  // }
  //
  // static void closeTracking() async {
  //   if (_trackingBox != null) {
  //     _trackingBox.close().then((value) {
  //       print("Tracking now is close");
  //     });
  //   }
  // }

  // static void clearTracking() async {
  //   if (_trackingBox != null && _trackingBox.isOpen) {
  //     _trackingBox.clear().then((value) {
  //       print("Tracking now is close");
  //     });
  //   }
  // }

  static Language getLanguage() {
    // if (_language == null) {
    //   _language = ;
    // }
    return _language??Language();
  }

  static Future<FlutterSecureStorage> getStorage() async {
    // if (_storage == null) {
    //   _storage = FlutterSecureStorage();
    // }
    return _storage ??FlutterSecureStorage();
  }

  static AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
