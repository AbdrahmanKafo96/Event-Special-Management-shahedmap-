import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../main.dart';

class Language extends ChangeNotifier{

  String _language=language;

  String get getLanguage => _language;

  set setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  // user profile  translated Strings ...

  String hSettings(){
    if(getLanguage == "AR"){
      return "الاعدادات";
    }else if(getLanguage == "EN"){
      return "Settings";
    }else{
      return "الاعدادات";
    }
  }
}