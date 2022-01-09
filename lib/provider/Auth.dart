import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/loginAndRegister/loginUI.dart';
import 'package:systemevents/model/Witnesse.dart';
import 'package:systemevents/model/user.dart';
import 'package:systemevents/services/dio.dart';
import 'dart:convert'  as convert;
import 'package:http/http.dart' as http;
import 'package:systemevents/singleton/singleton.dart';


class UserAuthProvider extends ChangeNotifier{

  User user=User();
  Future<bool> login(Map userData)async {
    try {
      print(userData);
      SharedPreferences prefs  = await Singleton.getPrefInstace();
      if(prefs !=null){
        final response =userData['userState'] == 'L' ?
        await http.post(Uri.parse("${Singleton.apiPath}/login"),  body: userData, )
            :
        await http.post(Uri.parse("${Singleton.apiPath}/register",) , body: userData,);
        print(response.statusCode);

        if(response.statusCode==200){

          var responseData = json.decode(response.body);
          print(responseData['message']);
          if(userData['userState']=='L'){
            if(responseData['message']=="تحقق من البريد الالكتروني وكلمة المرور"){
              showShortToast('تحقق من البريد الالكتروني وكلمة المرور', Colors.orange);
                return false;
            }else{
              user.user_id=responseData["user_id"];
              user.api_token=responseData["api_token"];

              prefs.setString('api_token', user.api_token);
              prefs.setInt('user_id', user.user_id);
              prefs.setString('email', responseData["email"]);

              return true ;
            }
          }
          //مرحبا بك
          if(responseData['status']=="failed"){
            showShortToast('تأكد من الحقول مدخلة بشكل صحيح', Colors.red);
            return false;
          }else{
            user.user_id=responseData['data']["user_id"];
            user.api_token=responseData['data']["api_token"];

            prefs.setString('api_token', user.api_token);
            prefs.setInt('user_id', user.user_id);
            prefs.setString('email', responseData['data']["email"]);

            return true ;
          }
        }else
        {
          showShortToast('لم تستطع الوصول لنظام حاول مرة اخرى', Colors.orange);
          return false;
        }
      }

      //return  user.api_token.isNotEmpty ?  true ;
      return true;
    } catch (e) {
      print(e);
    }
  }
  Future<bool> resetPassword(  String password ,String confPassword ,String user_id, String email ,
      BuildContext context) async {

    Map data={
      'password':password.trim(),
      'password_confirmation':confPassword.trim(),
      "user_id":user_id.trim(),
      "email":email.trim(),
    };

    final response = await http
        .post(Uri.parse('${Singleton.apiPath}/resetPasswordUser'), body: data);


    if (response.statusCode == 200) {
      var parsed = json.decode(response.body) ;
      if(parsed['message']=='success'){
        return true;
      } else {
        return false;
      }}
    else{
      showShortToast('لم تستطع الوصول للخادم حاول مرة اخرى', Colors.orange);
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs= await Singleton.getPrefInstace();
    String api_token=prefs.getString('api_token');

    Map userdata={ 'api_token': api_token, };

    final response =  await http.post(
        Uri.parse("${Singleton.apiPath}/logout"),body: userdata );
    if(response.statusCode==200){
      var responseData = json.decode(response.body);
      print(responseData);
      prefs.remove("api_token");
      prefs.remove("user_id");
      prefs.remove("email");

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => LoginUi()));
    }else{

      showShortToast('لم تستطع الوصول للخادم حاول مرة اخرى', Colors.orange);
    }
  }

  Future<bool> saveProfileData(Map userData  )async {
    try {

      final request =
      await http.MultipartRequest("POST", Uri.parse("${Singleton.apiPath}/saveUserData") ) ;
      request.fields['user_id'] = userData['user_id'].toString();
      request.fields['first_name'] = userData['first_name'];
      request.fields['father_name'] = userData['father_name'];
      request.fields['family_name'] = userData['family_name'];
      request.fields['country'] = userData['country'];
      request.fields['date_of_birth'] = userData['date_of_birth'];
      if(user.profilePicture!=null)
        request.files.add(
            http.MultipartFile('image',
                File(user.profilePicture.path).readAsBytes().asStream(),
                File(user.profilePicture.path).lengthSync(),
                filename:user.profilePicture.path.split("/").last
            ));
      var response=await  request.send() ;
      print(response.statusCode);
      if(response.statusCode==200){
        final respStr = await response.stream.bytesToString();
        var responseData= jsonDecode(respStr);
        print(responseData['message']);
        if(responseData['message']=='success'){
          print("yes");
          return true;
        }else{
          showShortToast('لم تتم عملية الحفظ بنجاح', Colors.orange);
          return false ;
        }
      }else
      {
        showShortToast('dddd', Colors.orange);
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
  Future<Witness>  checkState(var  result ) async {


    // // this method for check if the user has data before or no ...
    if(result !=null){
      Map data={
        'user_id':result,
      };

      final response =  await http.post(
          Uri.parse("${Singleton.apiPath}/getUser") ,body: data );
      if(response.statusCode==200){
        var res=jsonDecode(response.body);

        if(res['message']=='success'){
          return Witness.fromJson(res['data']) ;
        }
        else{
          return null;
        }
      }else{
        showShortToast('لم تستطع الوصول لنظام حاول مرة اخرى', Colors.orange);
        return null;
      }
    }
  }
  Future<bool> updateProfileData(Map userData  )async {
    try {
      final request =
      await http.MultipartRequest("POST", Uri.parse("${Singleton.apiPath}/updateUserData") ) ;
      request.fields['user_id'] = userData['user_id'].toString();
      request.fields['first_name'] = userData['first_name'];
      request.fields['father_name'] = userData['father_name'];
      request.fields['family_name'] = userData['family_name'];
      request.fields['country'] = userData['country'] ;
      request.fields['date_of_birth'] =  userData['date_of_birth'] ;
      if(user.profilePicture!=null)
        request.files.add(
            http.MultipartFile('image',
                File(user.profilePicture.path).readAsBytes().asStream(),
                File(user.profilePicture.path).lengthSync(),
                filename:user.profilePicture.path.split("/").last
            ));

      var response=await  request.send() ;

      if(response.statusCode==200){
        final respStr = await response.stream.bytesToString();
        var responseData= jsonDecode(respStr);
            print(responseData);
        if(responseData['message']=='success'){

          return true;
        }else{

          return false ;
        }
      }else
      {
        showShortToast('لم تستطع الوصول للخادم حاول مرة اخرى', Colors.orange);
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}