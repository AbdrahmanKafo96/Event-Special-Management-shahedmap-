import 'package:shahed/provider/language.dart';
import 'package:shahed/singleton/singleton.dart';
import '../provider/auth_provider.dart';


class SharedData{

 static Language _language ;
  static Language getGlobalLang(){
   if(_language==null){
     _language = SharedClass.getLanguage();
   }
    return _language;
  }
  static bool _state ;
  static  bool getUserState()   {
    if (_state == null) {
      SharedClass.getBox().then((value) async {

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
