
import 'package:flutter/material.dart';
import 'package:systemevents/models/navigation_item.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationItem _navigationItem = NavigationItem.home;

  NavigationItem get getNavigationItem => _navigationItem;

  void setNavigationItem(NavigationItem navigationItem) {
    _navigationItem = navigationItem;
    print("noti was called ");
    notifyListeners();
  }
}