import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  Notification() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showNotificationWithoutSound(String position) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1', 'location-bg',
        channelDescription: 'fetch location in background',
        playSound: false,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
    DarwinInitializationSettings(defaultPresentSound: false);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin?.show(
      0,
      'Location fetched',
      position.toString(),
      platformChannelSpecifics,
      payload: '',
    );
  }
}
