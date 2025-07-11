import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
    Notification() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher_my_location');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid ,iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings ,
        onDidReceiveNotificationResponse:null);
  }

 late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showNotificationWithoutSound(String position) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "fetchBackground", 'location-bg',
        channelDescription: 'fetch location in background',
        playSound: false,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();
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
