import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  Notification() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher_my_location');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid ,iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings ,
        onDidReceiveNotificationResponse:null);
  }
  void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showNotificationWithoutSound(String position) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "fetchBackground", 'location-bg',
        channelDescription: 'fetch location in background',
        playSound: false,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
    DarwinNotificationDetails( );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics ,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin?.show(
      0,
      'Location fetched',
      position.toString(),
      platformChannelSpecifics,
      payload: '',
    );
  }
}
