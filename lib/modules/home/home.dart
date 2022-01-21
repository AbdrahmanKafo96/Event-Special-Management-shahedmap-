import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:systemevents/main.dart';
import 'package:systemevents/models/Event.dart';
import 'package:systemevents/modules/home/dashboard.dart';
import 'package:systemevents/modules/home/event_screens/main_section.dart';
import 'package:systemevents/provider/auth_provider.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'settings_screens/settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'package:systemevents/notification/notification.dart' as notif;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position  position;

  // void _getUserPosition() async {
  //
  //   Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation,
  //       forceAndroidLocationManager: false)
  //       .then((position) {
  //     print(position);
  //   });
  //
  //   Position userLocation = await  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     position = userLocation;
  //     print(userLocation.longitude);
  //     print(userLocation.latitude);
  //   });
  // }
  var myMenuItems = <String>[
    'تسجيل الخروج',

  ];
  //State class
  int _activePage = 0;
  final List<Widget> _tabItems = [
    //,
    Dashboard(),
    Settings()
  ];

  @override
  void initState() {
    super.initState();
   // this._getUserPosition();
    Singleton.getPrefInstance().then((value){
      if(value.getInt('role_id')==4){
          Workmanager().initialize(
            callbackDispatcher,
            isInDebugMode: false,
          );
          Workmanager().registerPeriodicTask(
            "1",
            "fetchBackground",
            frequency: Duration(minutes: 15),
          );
      }
    });

  }
  void onSelect(item) {
    switch (item) {
      case 'تسجيل الخروج':
        Provider.of<UserAuthProvider>(context, listen: false).logout(context);
        break;

    }
  }
  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation,
        floatingActionButton: _activePage == 0
            ? FloatingActionButton(
                onPressed: () {
                  Provider.of<EventProvider>(context, listen: false).event=Event();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventSectionOne()),
                  );
                },tooltip: 'اضف حدث',
                child: const Icon(

                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
                backgroundColor: Colors.green,
              )
            : null,

        appBar: AppBar(
          leading: _activePage == 1
            //   ? IconButton(
            // tooltip: 'تسجيل الخروج',
            //       icon: Icon(
            //         Icons.logout,
            //       ),
            //       onPressed: () {
            //         Provider.of<UserAuthProvider>(context, listen: false)
            //             .logout(context);
            //       })
           ? PopupMenuButton<String>(
            onSelected: onSelect,
            itemBuilder: (BuildContext context) {
              return myMenuItems.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            })
              : SizedBox.shrink(),

          centerTitle: true,
          elevation: 1.0,
          titleSpacing: 1.0,
          title: Text(
            _activePage == 0 ? "الصفحة الرئيسية"  : "الاعدادت",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          //  key: _bottomNavigationKey,
          items: <Widget>[
            //  Icon(Icons.add,),
            Icon(
              Icons.home,
              color: Colors.white,
            ),

            Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ],
          backgroundColor: Colors.white,
          buttonBackgroundColor: Color(0xFF2d6335),
          color: Color(0xFF5a8f62),
          onTap: (index) {
            setState(() {
              _activePage = index;
            });
          },
        ),
        body: _tabItems[_activePage],
      ),
    );
  }

}

