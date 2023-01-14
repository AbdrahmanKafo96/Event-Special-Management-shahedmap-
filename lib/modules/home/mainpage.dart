import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/navigation_item.dart';
import 'package:shahed/modules/home/home.dart';
import 'package:shahed/modules/home/settings_screens/app_settings.dart';
import 'package:shahed/modules/home/settings_screens/about_screen.dart';
import 'package:shahed/modules/home/settings_screens/profile_view.dart';
import 'package:shahed/provider/navigation_provider.dart';
import 'settings_screens/reset_password/CreateNewPasswordView.dart';

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
        return HomePage();

      case NavigationItem.settings:
        return AppSettings();

      case NavigationItem.profilePage:
        return ProfilePage();

      case NavigationItem.resetPage:
        return CreateNewPasswordView();

      case NavigationItem.about:
        return About();
      default:
          return HomePage();
    }
  }
}
