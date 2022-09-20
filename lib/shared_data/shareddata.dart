import 'package:systemevents/singleton/singleton.dart';
import '../provider/auth_provider.dart';


class SharedData{

  static bool _state ;
  static  bool getUserState()   {
    if (_state == null) {
      Singleton.getBox().then((value) async {

        var user_id= value.get('user_id');
        if (value.get('role_id') == 4) {
          UserAuthProvider.getBeneID(user_id);
          _state = true;
        }else   {
          _state=false;
           UserAuthProvider().checkState(user_id);
        }
      });
    }
    return _state;
  }
  static resetValue(){
    _state=null;
  }

}
