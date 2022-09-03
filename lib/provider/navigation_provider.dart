
import 'package:flutter/material.dart';
import 'package:systemevents/models/navigation_item.dart';

class NavigationProvider extends ChangeNotifier{
  NavigationItem _navigationItem =NavigationItem.home;

  NavigationItem get getnNavigationItem => _navigationItem;

  set setNavigationItem(NavigationItem item) {
    _navigationItem = item;
    notifyListeners();
  }
}