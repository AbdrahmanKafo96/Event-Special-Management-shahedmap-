import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/models/navigation_item.dart';
import 'package:systemevents/modules/home/home.dart';
import 'package:systemevents/modules/home/settings_screens/AppSettings.dart';
import 'package:systemevents/modules/home/settings_screens/ResetPassword/CreateNewPasswordView.dart';
import 'package:systemevents/modules/home/settings_screens/about_screen.dart';
import 'package:systemevents/modules/home/settings_screens/profile_view.dart';
import 'package:systemevents/provider/navigation_provider.dart';
import 'package:systemevents/singleton/singleton.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => buildPages();

  Widget buildPages() {
    final provider = Provider.of<NavigationProvider>(context);
    final navigationItem = provider.getNavigationItem;

    switch (navigationItem) {
      case NavigationItem.home:
        Singleton.getPrefInstance();
        return HomePage();

      case NavigationItem.settings:
        return AppSettings();

      case NavigationItem.profilePage:
        return ProfilePage();

      case NavigationItem.resetPage:
        return CreateNewPasswordView();

      case NavigationItem.about:
        return About();


    }
  }
}
