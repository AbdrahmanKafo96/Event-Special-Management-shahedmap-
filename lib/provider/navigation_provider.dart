import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shahed/models/navigation_item.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationItem _navigationItem = NavigationItem.home;
  Box? _box;

  Box get getBox => _box!;

  set setBox(Box value) {
    _box = value;
    notifyListeners();
  }

  void setNavigationItem(NavigationItem navigationItem) {
    _navigationItem = navigationItem;
    notifyListeners();
  }
  void reset( ) {
    _navigationItem = NavigationItem.home;
    //notifyListeners();
  }

  NavigationItem get getNavigationItem => _navigationItem;
}
