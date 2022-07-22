import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/widgets/customToast.dart';
import 'package:systemevents/modules/login/login_screen.dart';
import 'package:systemevents/models/witness.dart';
import 'package:systemevents/models/user.dart';
import 'package:systemevents/services/dio.dart';
import 'dart:convert'  as convert;
import 'package:http/http.dart' as http;
import 'package:systemevents/singleton/singleton.dart';


class UserAuthProvider extends ChangeNotifier{

  User user=User();
  Future<bool> login(Map userData)async {

    try {
      final storage = await Singleton.getStorage()  ;
    //  String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
      final prefs = await Singleton.getPrefInstance();


      if(prefs !=null){
        final response =userData['userState'] == 'L' ?
        await http.post(Uri.parse("${Singleton.apiPath}/login"),  body:jsonEncode( userData),
          headers: {
        'Accept':'application/json',
        //'Authorization' : 'Bearer $value',
          'content-type': 'application/json',
        }, )
            :
        await http.post(Uri.parse("${Singleton.apiPath}/register",) , body: jsonEncode( userData),headers: {
         'Accept':'application/json',
          // 'Authorization' : 'Bearer $value',
         'content-type': 'application/json',
        },);


        if(response.statusCode==200){

          var responseData = json.decode(response.body);
            print(responseData);
          if(userData['userState']=='L'){
            if(responseData['message']=="تحقق من البريد الالكتروني وكلمة المرور"){
              showShortToast('تحقق من البريد الالكتروني وكلمة المرور', Colors.red);
                return false;
            }
            else if(responseData['message']=="لاتستطيع تسجيل الدخول لان حسابك محظور"){
              showShortToast("لاتستطيع تسجيل الدخول لان حسابك محظور", Colors.red);
              return false;
            }
            else{
              user.user_id=responseData['result']['original']['data']["user_id"];
              user.api_token=responseData['result']['original']['data']["api_token"];

              await storage.write(key: 'api_token',
                  value:  user.api_token  ,aOptions: Singleton.getAndroidOptions());
              await storage.write(key: 'token',
                  value:  responseData['token'] ,aOptions: Singleton.getAndroidOptions());

              prefs.setInt('user_id', user.user_id);
              prefs.setString('email', responseData['result']['original']['data']["email"]);
              prefs.setInt('role_id', int.parse(responseData ['result']['original']['data']["role_id"].toString()));


              return true ;
            }
          }
          //مرحبا بك

          if(responseData['status']=="failed"){
            //print(responseData['error'].toString());
            if(responseData['error'].toString()=="{email: [قيمة حقل email مُستخدمة من قبل.]}")
            showShortToast( 'عفوا البريد الالكتروني مستخدم من قبل', Colors.red);
            else{
              showShortToast( 'عفوا تأكد من المدخلات', Colors.red);
            }
            return false;
          }else{
            user.user_id=responseData ['result']['original']['data']["user_id"];
            user.api_token=responseData ['result']['original']['data']["api_token"];


            await storage.write(key: 'api_token',
                value: user.api_token  ,aOptions: Singleton.getAndroidOptions());
            await storage.write(key: 'token',
                value:  responseData['token'] ,aOptions: Singleton.getAndroidOptions());
            prefs.setInt('user_id', user.user_id);
            prefs.setString('email', responseData ['result']['original']['data']["email"]);
            prefs.setInt('role_id', int.parse(responseData ['result']['original']['data']["role_id"].toString()));

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

    final storage = await Singleton.getStorage()  ;
    String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
    try{
      Map data={
        'password':password.trim(),
        'password_confirmation':confPassword.trim(),
        "user_id":user_id.trim(),
        "email":email.trim(),
      };

      final response = await http.post(Uri.parse('${Singleton.apiPath}/resetPasswordUser'), body: jsonEncode(data),headers: {
        'Accept':'application/json',
        'Authorization' : 'Bearer $value',
        'content-type': 'application/json',
      },);


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
    }catch (e){

    }
  }

  void logout(BuildContext context) async {
   try{
    SharedPreferences prefs= await Singleton.getPrefInstance();
     final storage = await Singleton.getStorage()  ;
     String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());

     String api_token=await storage.read(key: 'api_token' ,aOptions: Singleton.getAndroidOptions());

     Map userdata={ 'api_token': api_token, 'device_name':await PlatformDeviceId.getDeviceId,};

     final response =  await http.post(
         Uri.parse("${Singleton.apiPath}/logout"),body: jsonEncode(userdata) ,headers: {
       'Accept':'application/json',
       'Authorization' : 'Bearer $value',
       'content-type': 'application/json',
     },);
     if(response.statusCode==200){
       //var responseData = json.decode(response.body);

       await storage.delete(key: 'api_token',aOptions: Singleton.getAndroidOptions());
       await storage.delete(key: 'token',aOptions: Singleton.getAndroidOptions());
       prefs.remove("user_id");
       prefs.remove("email");


       Navigator.pushReplacement(context,
           MaterialPageRoute(builder: (_) => LoginUi()));
     }else{

       showShortToast('لم تستطع الوصول للخادم حاول مرة اخرى', Colors.orange);
     }
   }catch(e){

   }
  }

  Future<bool> saveProfileData(Map userData  )async {
    try {
      final storage = await Singleton.getStorage()  ;
      String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
      final request =
      await http.MultipartRequest("POST", Uri.parse("${Singleton.apiPath}/saveUserData",) ) ;
      request.headers.addAll({"Authorization":"Bearer $value" });

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

      if(response.statusCode==200){
        final respStr = await response.stream.bytesToString();
        var responseData= jsonDecode(respStr);


        if(responseData['message']=='success'){


          return true;
        }else{
          showShortToast('لم تتم عملية الحفظ بنجاح', Colors.orange);
          return false ;
        }
      }else
      {
        showShortToast('خطاء', Colors.orange);
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
  Future<Witness>  checkState(var  result ) async {
    try{

      // // this method for check if the user has data before or no ...
      if(result !=null){
        Map data={
          'user_id':result,
        };
        final storage = await Singleton.getStorage()  ;
        String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());

        final response =  await http.post(
            Uri.parse("${Singleton.apiPath}/getUser") ,body:  data , headers: {

        'Authorization' : 'Bearer $value',

        },);
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
    }catch (e){

    }
  }
  Future<bool> updateProfileData(Map userData  )async {
    try {
      final storage = await Singleton.getStorage()  ;
      String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
      final request =
      await http.MultipartRequest("POST", Uri.parse("${Singleton.apiPath}/updateUserData") ) ;
      request.headers.addAll({"Authorization":"Bearer $value" });
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

  Future<void> forgotpassword(String email) async {
    try{

      // // this method for check if the user has data before or no ...
      if(email !=null){
        Map data={
          'email':email,
        };
         
        final response =  await http.post(
          Uri.parse("${Singleton.apiPath}/forgotpassword") ,body:  data   ,);
        if(response.statusCode==200){
          var res=jsonDecode(response.body);
          showShortToast('تحقق من البريد الالكتروني', Colors.orange);
        }else{

          showShortToast(' ', Colors.orange);
          return null;
        }
      }
    }catch (e){

    }
  }
}