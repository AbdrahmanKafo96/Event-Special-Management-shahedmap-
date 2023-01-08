import 'package:flutter/material.dart';


class CounterProvider extends ChangeNotifier {

  bool _counterNotification =false;
  bool _counterMissions =false;

  bool get getCounterNotification => _counterNotification;

  set setCounterNotification(bool value) {
    _counterNotification = value;
    notifyListeners();
  }

  bool get getCounterMissions => _counterMissions;

  set setCounterMissions(bool value) {
    _counterMissions = value;
    notifyListeners();
  }
}