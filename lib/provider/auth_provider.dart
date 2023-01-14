import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:workmanager/workmanager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:shahed/modules/authentications/login_screen.dart';
import 'package:shahed/models/witness.dart';
import 'package:shahed/models/user.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shahed/singleton/singleton.dart';
import 'package:location/location.dart' as loc;
import '../widgets/checkInternet.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class UserAuthProvider extends ChangeNotifier {
  User user = User();

  Future<bool?> login(Map userData) async {
    try {
      final storage = await SharedClass.getStorage();
      //  String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
      final box = await SharedClass.getBox();
      print(userData);
      if (box != null) {

        final response = userData['userState'] == 'L'
            ? await http.post(
                Uri.parse("${SharedClass.apiPath}/login"),
                body: jsonEncode(userData),
                headers: {
                  'Accept': 'application/json',
                  //'Authorization' : 'Bearer $value',
                  'content-type': 'application/json',
                },
              )
            : await http.post(
                Uri.parse(
                  "${SharedClass.apiPath}/register",
                ),
                body: jsonEncode(userData),
                headers: {
                  'Accept': 'application/json',
                  // 'Authorization' : 'Bearer $value',
                  'content-type': 'application/json',
                },
              );

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          print(responseData );
          if (userData['userState'] == 'L') {
              print(userData['userState']);

            // showShortToast(responseData['message'], Colors.redAccent);
            if (responseData['message'] ==
                "تحقق من البريد الالكتروني وكلمة المرور") {
              showShortToast(
                  SharedData.getGlobalLang().checkEmailPassword(), Colors.red);
              return false;
            } else if (responseData['message'] ==
                "لاتستطيع تسجيل الدخول لان حسابك محظور") {
              showShortToast(
                 SharedData.getGlobalLang().blockUserMessage() , Colors.red);
              return false;
            } else {print(responseData['result']['original']['data']["api_token"]);
              user.user_id =
                  responseData['result']['original']['data']["user_id"];
              user.api_token =
                  responseData['result']['original']['data']["api_token"];

              await storage.write(
                  key: 'api_token',
                  value: user.api_token,
                  );
              await storage.write(
                  key: 'token',
                  value: responseData['token'],
                  );

              box.put('user_id', user.user_id);
              box.put(
                  'email', responseData['result']['original']['data']["email"]);
              box.put(
                  'role_id',
                  int.parse(responseData['result']['original']['data']
                          ["role_id"]
                      .toString()));
              SharedData.getUserState();

              return true;
            }
          }
          //تحتاج تعديل الان 9\29\20222

          print(responseData['status']);
          if (responseData['status'] == "failed") {

            if (responseData['error']['email'][0].toString() ==
                "The email has already been taken.")
              showShortToast(
                  SharedData.getGlobalLang().emailAlreadyUsed(), Colors.red);
            else {
              showShortToast(SharedData.getGlobalLang().pleaseCheckYourInputs(), Colors.red);
            }
            return false;
          } else {

            user.user_id =
                responseData['result']['original']['data']["user_id"];
            user.api_token =
                responseData['result']['original']['data']["api_token"];
            print(responseData['result']['original']['data']["api_token"]);
            await storage.write(
                key: 'api_token',
                value: user.api_token,
                aOptions: SharedClass.getAndroidOptions());
            await storage.write(
                key: 'token',
                value: responseData['token'],
                aOptions: SharedClass.getAndroidOptions());
            box.put('user_id', user.user_id);
            box.put(
                'email', responseData['result']['original']['data']["email"]);
            box.put(
                'role_id',
                int.parse(responseData['result']['original']['data']["role_id"]
                    .toString()));
            SharedData.getUserState();
            return true;
          }
        } else {
          showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
          return false;
        }
      }

      //return  user.api_token.isNotEmpty ?  true ;
    //  return true;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> resetPassword(String? password, String? confPassword,
      String? user_id, String? email, BuildContext? context) async {
    final storage = await SharedClass.getStorage();
    String? value = await storage.read(
        key: "token", aOptions: SharedClass.getAndroidOptions());
    try {
      Map data = {
        'password': password!.trim(),
        'password_confirmation': confPassword!.trim(),
        "user_id": user_id!.trim(),
        "email": email!.trim(),
      };

      final response = await http.post(
        Uri.parse('${SharedClass.apiPath}/resetPasswordUser'),
        body: jsonEncode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value',
          'content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        if (parsed['message'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void logout(BuildContext context) async {
     try {
      Box box  = await SharedClass.getBox();
      if(SharedClass.getBGState())
        await    bg.BackgroundGeolocation.stop().then((value) async{
      await EventProvider().stopTracking( box.get('user_id'),
          int.parse( box.get('beneficiarie_id')) );
         });
      final storage = await SharedClass.getStorage();
      String? value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());

      String? api_token = await storage.read(
          key: 'api_token', aOptions: SharedClass.getAndroidOptions());
      DeviceInfoPlugin  deviceInfo= DeviceInfoPlugin();
      String id ='';
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          id=androidInfo.id;
      }
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          id=iosInfo.identifierForVendor!;
      }

      Map userdata = {
        'api_token': api_token,
        'device_name':id,
      };
      checkInternetConnectivity(context).then((bool state) async {
        if (state) {

          final response = await http.post(
            Uri.parse("${SharedClass.apiPath}/logout"),
            body: jsonEncode(userdata),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $value',
              'content-type': 'application/json',
            },
          );
          if (response.statusCode == 200) {
              var responseData = json.decode(response.body);
            print(responseData);
            await storage.delete(
                key: 'api_token', aOptions: SharedClass.getAndroidOptions());
             await storage.delete(
                 key: 'token', aOptions: SharedClass.getAndroidOptions());


            box.delete("user_id");
            box.delete("sender_id");
            box.delete("email");
            box.delete("role_id");
            box.delete("beneficiarie_id");
            box.delete("unitname");
            box.delete('lat_endpoint');
            box.delete('lng_endpoint');
            box.delete('traffic');
            box.delete('myactive');
            box.delete('btnmyactive');

            SharedData.resetValue();
             Workmanager().cancelByTag('fetchLocation');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginUi()));
          } else {
            print(response.body);
            showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> saveProfileData(Map userData) async {
    try {
      final storage = await SharedClass.getStorage();
      String? value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final request = await http.MultipartRequest(
          "POST",
          Uri.parse(
            "${SharedClass.apiPath}/saveUserData",
          ));
      request.headers.addAll({"Authorization": "Bearer $value"});

      request.fields['user_id'] = userData['user_id'].toString();
      request.fields['first_name'] = userData['first_name'];
      request.fields['father_name'] = userData['father_name'];
      request.fields['family_name'] = userData['family_name'];
      request.fields['country'] = userData['country'];
      request.fields['date_of_birth'] = userData['date_of_birth'];
      if (user.profilePicture != null)
        request.files.add(http.MultipartFile(
            'image',
            File(user.profilePicture!.path).readAsBytes().asStream(),
            File(user.profilePicture!.path).lengthSync(),
            filename: user.profilePicture!.path.split("/").last));
      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var responseData = jsonDecode(respStr);

        if (responseData['message'] == 'success') {
          return true;
        } else {
          showShortToast(SharedData.getGlobalLang().saveWasNotSuccessful(), Colors.orange);
          return false;
        }
      } else {
        showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Witness?> checkState(var result) async {
    try {
      // // this method for check if the user has data before or no ...
      if (result != null) {
        Map data = {
          'user_id': result.toString(),
        };
        final box = await SharedClass.getBox();
        final storage = await SharedClass.getStorage();
        String? value = await storage.read(
            key: "token", aOptions: SharedClass.getAndroidOptions());

        final response = await http.post(
          Uri.parse("${SharedClass.apiPath}/getUser"),
          body: data,
          headers: {
            'Authorization': 'Bearer $value',
          },
        );
        if (response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['message'] == 'success') {
            box.put('unitname', res['data']['first_name']);
            return Witness.fromJson(res['data']);
          } else {
            return null;
          }
        } else {
          showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
          return null;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> updateProfileData(Map userData) async {
    try {
      final storage = await SharedClass.getStorage();
      String? value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final request = await http.MultipartRequest(
          "POST", Uri.parse("${SharedClass.apiPath}/updateUserData"));
      request.headers.addAll({"Authorization": "Bearer $value"});
      request.fields['user_id'] = userData['user_id'].toString();
      request.fields['first_name'] = userData['first_name'];
      request.fields['father_name'] = userData['father_name'];
      request.fields['family_name'] = userData['family_name'];
      request.fields['country'] = userData['country'];
      request.fields['date_of_birth'] = userData['date_of_birth'];
      if (user.profilePicture != null)
        request.files.add(http.MultipartFile(
            'image',
            File(user.profilePicture!.path).readAsBytes().asStream(),
            File(user.profilePicture!.path).lengthSync(),
            filename: user.profilePicture!.path.split("/").last));

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var responseData = jsonDecode(respStr);

        if (responseData['message'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> forgotpassword(String email) async {
    try {
      // // this method for check if the user has data before or no ...
      if (email != null) {
        Map data = {
          'email': email,
        };

        final response = await http.post(
          Uri.parse("${SharedClass.apiPath}/forgotpassword"),
          body: data,
        );
        if (response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['error']['email'][0].toString() ==
              "The selected email is invalid.") {
            showShortToast(SharedData.getGlobalLang().checkEmailInput(), Colors.orange);
            return;
          }

          showShortToast(SharedData.getGlobalLang().checkInbox(), Colors.green);
          return;
        } else {
          showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
          return null;
        }
      }
    } catch (e) {}
  }

  static Future<void> getBeneID(var result) async {
    try {
      if (result != null) {
        Map data = {
          'user_id': result.toString(),
        };
        Box box = await SharedClass.getBox();
        final storage = await SharedClass.getStorage();
        String? value = await storage.read(
            key: "token", aOptions: SharedClass.getAndroidOptions());

        final response = await http.post(
          Uri.parse("${SharedClass.apiPath}/findBenID"),
          body: data,
          headers: {
            'Authorization': 'Bearer $value',
          },
        );

        if (response.statusCode == 200) {
          var res = jsonDecode(response.body);
          box.put('beneficiarie_id', res['data']['beneficiarie_id']);
          box.put('unitname', res['data']['name']);
        } else {
          showShortToast(SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
          return null;
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
