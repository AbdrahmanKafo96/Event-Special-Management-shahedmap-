import 'package:systemevents/singleton/singleton.dart';

class SharedData{

  static bool _state ;
  static  bool getUserState()  {
    if (_state == null) {
      Singleton.getPrefInstance().then((value) {
        if (value.getInt('role_id') == 4) {
          _state = true;
        }else{
          _state=false;
        }
      });
    }
    return _state;
  }
  static resetValue(){
    _state=null;
  }
}