import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shahed/models/markermodel.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:shahed/models/category.dart';
import 'package:shahed/models/event.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:intl/intl.dart';
import '../models/mission.dart';

class EventProvider extends ChangeNotifier {
  Event event = Event();

  addEvent(Map userData) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());

      var _count = 1;
      var request = http.MultipartRequest(
          "POST", Uri.parse("${SharedClass.apiPath}/save_event"));
      request.headers.addAll({"Authorization": "Bearer $value"});
      if (userData['description'] != null)
        request.fields['description'] = userData['description'];
      request.fields['event_name'] = userData['event_name'];
      request.fields['sender_id'] = userData['sender_id'].toString();
      request.fields['senddate'] = userData['senddate'];
      request.fields['eventtype'] = userData['eventtype'];
      request.fields['lat'] = userData['lat'];
      request.fields['lng'] = userData['lng'];
      // code below for camera image ...

      if (event.getXFile != null) {
        if (event.getXFile.length >= 1 && event.getXFile.length <= 4) {
          event.setListSelected = event.getXFile;

          for (int i = 0; i < event.getListSelected.length; i++) {
            request.files.add(http.MultipartFile(
                'image${_count++}',
                File(event.getListSelected[i].path).readAsBytes().asStream(),
                File(event.getListSelected[i].path).lengthSync(),
                filename: event.getListSelected[i].path.split("/").last));
          }
        }
      }

      if (event.getVideoFile != null)
        request.files.add(http.MultipartFile(
            'video',
            File(event.getVideoFile.path).readAsBytes().asStream(),
            File(event.getVideoFile.path).lengthSync(),
            filename: event.getVideoFile.path.split("/").last));

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var res = jsonDecode(respStr);

        if (res['error'].toString() != 'null') {
          showShortToast(res['error'].toString(), Colors.red);
          return false;
        }
        if (res['message'] == 'لاتستطيع ارسال حدث لان حسابك محظور') {
          showShortToast(
              SharedData.getGlobalLang().blockEventMessage(), Colors.red);
          return false;
        }
        if (res['status'] == 'success') {
          event.dropAll();
          //event=Event();
          return true;
        } else {
          return false;
        }
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        return false;
      }
    } catch (e) {}
  }

  Future update_position(Map data) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());

      final response = await http.post(
        Uri.parse('${SharedClass.apiPath}/update_position'),
        body: jsonEncode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value',
          'content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == 1) {
          return 'se';
        }
        return 'unse';
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to delete post.');
      }
    } catch (e) {}
  }

  Future deleteEvent(int addede_id, int sender_id) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      Map data = {
        'sender_id': sender_id.toString(),
        'addede_id': addede_id.toString(),
      };
      final response = await http.delete(
        Uri.parse('${SharedClass.apiPath}/deleteEvent'),
        body: jsonEncode(data),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $value',
          'content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Event.fromJson(jsonDecode(response.body));
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to delete post.');
      }
    } catch (e) {}
  }

  updateEvent(Map userData) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      //var _count = 1;
      var request = http.MultipartRequest(
          "POST", Uri.parse("${SharedClass.apiPath}/updateEvent"));
      request.headers.addAll({"Authorization": "Bearer $value"});
      request.fields['description'] = userData['description'];
      request.fields['user_id'] = userData['user_id'].toString();
      request.fields['addede_id'] = userData['addede_id'].toString();
      request.fields['event_name'] = userData['event_name'];

      if (event.getXFile != null) if (event.getXFile.length > 0) {
        if (event.getXFile[0] != null)
          request.files.add(http.MultipartFile(
              'image1',
              File(event.getXFile[0].path).readAsBytes().asStream(),
              File(event.getXFile[0].path).lengthSync(),
              filename: event.getXFile[0].path.split("/").last));

        if (event.getXFile[1] != null)
          request.files.add(http.MultipartFile(
              'image2',
              File(event.getXFile[1].path).readAsBytes().asStream(),
              File(event.getXFile[1].path).lengthSync(),
              filename: event.getXFile[1].path.split("/").last));

        if (event.getXFile[2] != null)
          request.files.add(http.MultipartFile(
              'image3',
              File(event.getXFile[2].path).readAsBytes().asStream(),
              File(event.getXFile[2].path).lengthSync(),
              filename: event.getXFile[2].path.split("/").last));

        if (event.getXFile[3] != null)
          request.files.add(http.MultipartFile(
              'image4',
              File(event.getXFile[3].path).readAsBytes().asStream(),
              File(event.getXFile[3].path).lengthSync(),
              filename: event.getXFile[3].path.split("/").last));
      }

      if (event.getVideoFile != null)
        request.files.add(http.MultipartFile(
            'video',
            File(event.getVideoFile.path).readAsBytes().asStream(),
            File(event.getVideoFile.path).lengthSync(),
            filename: event.getVideoFile.path.split("/").last));

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        var respo = jsonDecode(respStr);

        if (respo['message'] == 'لاتستطيع تعديل الحدث لان حسابك محظور') {
          showShortToast(
              SharedData.getGlobalLang().blockEditEventMessage(), Colors.red);
          return false;
        }
        if (respo['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        return false;
      }
    } catch (e) {}
  }

  //  we need to close connection after call these methods
  Future<dynamic> fetchEventDataByEventId(int addede_id) async {
    try {
      Map data = {
        'addede_id': addede_id.toString(),
      };
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());

      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/getEvent'),
          body: jsonEncode(data),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $value',
            'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);

        return parsed;
        // return parsed.map<Event>((json) => Event.fromJson(json)).toList();
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
      }
    } catch (e) {}
  }

//  we need to close connection after call these methods
  Future<List<CategoryClass>> fetchEventCategories() async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final response = await http.get(
          Uri.parse('${SharedClass.apiPath}/fetchEventCategories'),
          headers: {
            //'Accept':'application/json',
            'Authorization': 'Bearer $value',
            //  'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        // return json.decode(response.body);
        return parsed
            .map<CategoryClass>((json) => CategoryClass.fromJson(json))
            .toList();
        // return  CategoryClass.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load posts');
      }
    } catch (e) {}
  }

  Future<List<EventType>> fetchEventTypes() async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final response = await http
          .get(Uri.parse('${SharedClass.apiPath}/fetchEventTypes'), headers: {
        // 'Accept':'application/json',
        'Authorization': 'Bearer $value',
        // 'content-type': 'application/json',
      });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        // return json.decode(response.body);
        return parsed
            .map<EventType>((json) => EventType.fromJson(json))
            .toList();
        // return  CategoryClass.fromJson(jsonDecode(response.body));
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {}
  }

  removeImage(int addede_id, int index) async {
    try {
      index += 1;

      Map data = {
        'addede_id': addede_id.toString(),
        'index': index.toString(),
      };
      // final storage = await Singleton.getStorage()  ;
      //String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
      final response = await http.post(
        Uri.parse('${SharedClass.apiPath}/removeImage'),
        body: data,
        // headers: {
        //   // 'Accept':'application/json',
        //   'Authorization': 'Bearer $value',
        //   // 'content-type': 'application/json',
        // }
      );

      if (response.statusCode == 200) {
        final parsed = response.body;

        return parsed;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  removeVideo(int addede_id) async {
    try {
      Map data = {
        'addede_id': addede_id.toString(),
      };
      // final storage = await Singleton.getStorage()  ;
      //String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
      final response = await http.post(
        Uri.parse('${SharedClass.apiPath}/removeVideo'),
        body: data,
        // headers: {
        //   // 'Accept':'application/json',
        //   'Authorization': 'Bearer $value',
        //   // 'content-type': 'application/json',
        // }
      );

      if (response.statusCode == 200) {
        final parsed = response.body;

        return parsed;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<List<Event>> fetchAllListByUserId(int sender_id) async {
    try {
      Map data = {
        'sender_id': sender_id.toString(),
      };
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/fetchAllListByUserId'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json
            .decode(response.body)['collection']
            .cast<Map<String, dynamic>>();

        return parsed.map<Event>((json) => Event.fromJson(json)).toList();
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<List<Respo>> getAllRespons(int user_id) async {
    try {
      Map data = {
        'user_id': user_id.toString(),
      };
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/getAllRespons'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed =
            json.decode(response.body)['data'].cast<Map<String, dynamic>>();

        return parsed.map<Respo>((json) => Respo.fromJson(json)).toList();
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<List<Event>> fetchSearchedEvent(int addede_id) async {
    try {
      Map data = {
        'addede_id': addede_id.toString(),
      };
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/getEvent'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed.map<Event>((json) => Event.fromJson(json)).toList();
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<dynamic> searchData(int sender_id) async {
    try {
      Map data = {
        'sender_id': sender_id.toString(),
      };
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      final response = await http.post(
        Uri.parse('${SharedClass.apiPath}/fetchAllListByUserId'),
        body: data,
        // headers: {
        //   // 'Accept':'application/json',
        //   'Authorization': 'Bearer $value',
        //   // 'content-type': 'application/json',
        // }
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        if (parsed['data'] == 'success')
          return parsed['collection'];
        else
          return false;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<bool> updateNoti(int user_id, int notification_id) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      Map data = {
        'user_id': user_id.toString(),
        'notification_id': notification_id.toString(),
      };
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/updateNoti'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        if (parsed['message'] == 'success')
          return true;
        else
          return false;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  } Future<bool> updateMissionSeen(String user_id , mission_id) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      Map data = {
        'user_id': user_id ,
        'mission_id': mission_id ,
      };
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/updateMissionSeen'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        print(parsed['message']);
        print(response.body);
        if (parsed['message'] == 'success')
          return true;
        else
          return false;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<dynamic> getRespo(int user_id, int notification_id) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      Map data = {
        'user_id': user_id.toString(),
        'notification_id': notification_id.toString(),
      };
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/getRespo'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        return parsed;
        // else
        //   return false;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<bool> stopTracking(int sender_id, int beneficiarie_id) async {
    try {
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      Map data = {
        'sender_id': sender_id.toString(),
        'beneficiarie_id': beneficiarie_id.toString(),
      };
      print(value);
      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/close_track'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        if (parsed['status'] == 'success')
          return true;
        else
          return false;
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        return false;
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<List<MarkerModel>> getEvents() async {
    try {
      // var now = new DateTime.now();
      // var formatter = new DateFormat('yyyy-MM-dd');
      // String formattedDate = formatter.format(now);

      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());
      // Map data = {
      //  // 'date':formattedDate.toString(),
      //   'date':"2022-10-01",
      // };

      final response = await http
          .get(Uri.parse('${SharedClass.apiPath}/getevents'), headers: {
        // 'Accept':'application/json',
        'Authorization': 'Bearer $value',
        // 'content-type': 'application/json',
      });

      if (response.statusCode == 200) {
        if (response.body.length > 0) {
          final parsed =
              json.decode(response.body).cast<Map<String, dynamic>>();
          return parsed
              .map<MarkerModel>((json) => MarkerModel.fromJson(json))
              .toList();
        }
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }

  Future<List<Mission>> getMissions(String user_id, ben_id) async {
    try {
      Map data = {
        'user_id': user_id,
        'ben_id': ben_id,
      };
      final storage = await SharedClass.getStorage();
      String value = await storage.read(
          key: "token", aOptions: SharedClass.getAndroidOptions());

      final response = await http.post(
          Uri.parse('${SharedClass.apiPath}/getmissions'),
          body: data,
          headers: {
            // 'Accept':'application/json',
            'Authorization': 'Bearer $value',
            // 'content-type': 'application/json',
          });
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<Mission>((json) => Mission.fromJson(json)).toList();
      } else {
        showShortToast(
            SharedData.getGlobalLang().unableAccessSystem(), Colors.orange);
        throw Exception('Failed to load List');
      }
    } catch (e) {}
  }
}
