import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/event.dart';
import 'dart:convert';
import 'package:shahed/modules/home/dashboard/dashboard.dart';
import 'package:shahed/modules/home/event_screens/main_section.dart';
import 'package:shahed/modules/home/tracking/mission_track.dart';
import 'package:shahed/modules/home/tracking/tracking_user.dart';
import 'package:shahed/modules/home/tracking/unit_tracking.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:shahed/widgets/custom_drawer.dart';
import 'package:shahed/widgets/custom_indecator.dart';
import 'package:weather/weather.dart' as we;
import 'package:weather/weather.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loader = false;
  String countryName = "";
  String subAdminArea = "";
  String weather = "";
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  // GlobalKey _appbarkey = GlobalKey();
  Box box;
  var provider;
  var  description;
  double latitude,long;

  @pragma('vm:entry-point')
  void openPage(var ro ,{double lat ,lng} ){


  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MissionTracking( latLngDestination:
      LatLng(lat==null?latitude:lat,lng==null?long :lng)),
    ),
  );
}

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: openPage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification  notification = message.notification;
      AndroidNotification  android = message.notification .android;
      if (notification != null && android != null) {
        var s=message.toMap()['notification']['body'];
        print(jsonDecode(s)['description']);
        setState(() {
          description= jsonDecode(s)['description'];
          latitude=double.parse(jsonDecode(s)['lat_f']);
          long= double.parse(jsonDecode(s)['lng_f']);
        });
// body: {"description":"one way","lat_s":"32.855193","lng_s":"13.079033",
        // "lat_f":"32.839617","lng_f":"13.080063"},

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification  notification = message.notification;
      AndroidNotification  android = message.notification .android;
      if (notification != null && android != null) {
        var s=message.toMap()['notification']['body'];
        print(  jsonDecode(s)['description'] );

        openPage("",lat:double.parse(jsonDecode(s)['lat_f']) ,
            lng:double.parse(jsonDecode(s)['lng_f']) );
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {

      if (message != null) {
        var s=message.toMap()['notification']['body'];
        print(  jsonDecode(s)['description'] );
        print('TERMINATED');
        openPage("",lat:double.parse(jsonDecode(s)['lat_f']) ,
            lng:double.parse(jsonDecode(s)['lng_f']) );
       }
    });
     openBox();
    _getUserLocation();
  }

  void openBox() {
    SharedClass.getBox().then((value) {
      setState(() {
        box = value;
        loader = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            checkInternetConnectivity(context).then((bool value) async {
              if (value) {
                Provider.of<EventProvider>(context, listen: false).event =
                    Event();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventSectionOne()),
                );
              }
            });
          },
          tooltip: SharedData.getGlobalLang().addEvent(),
          child: const Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
            size: 24,
          ),
          backgroundColor: Colors.deepOrange,
        ),
        appBar: customAppBar(
          context,
          title: SharedData.getGlobalLang().homePage(),
          icon: FontAwesomeIcons.house,
          actions: [
            SharedData.getUserState() == true
                &&
                SharedData.getUserState() == false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.track_changes),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserTracking()),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: !loader
            ? customCircularProgressIndicator()
            : ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      //  side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    //  color:Color(0xFF5a8f62),
                    elevation: 2.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff33333d),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                " ${SharedData.getGlobalLang().Hello()} ${box.get('unitname')}!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Icon(
                                FontAwesomeIcons.globe,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "$countryName",
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Icon(
                                FontAwesomeIcons.temperatureThreeQuarters,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "${weather}",
                                style: TextStyle(color: Colors.white),
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                              ),
                              Icon(
                                FontAwesomeIcons.locationCrosshairs,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  subAdminArea,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dashboard(),
                ],
              ),
        drawer: CustomDrawer());
  }

  _getUserLocation() async {
    LocationData myLocation;
    String error;
    Location location = Location();
    try {
      myLocation = await location.getLocation();
      we.WeatherFactory wf = SharedClass.getWeatherFactory();
      we.Weather w = await wf.currentWeatherByLocation(
          myLocation.latitude, myLocation.longitude);

      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: myLocation.latitude,
          longitude: myLocation.longitude,
          googleMapApiKey: "${SharedClass.mapApiKey}");
      setState(() {
        countryName = data.country;
        subAdminArea = data.address;
        weather = w.temperature.celsius.toInt().toString();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }

      myLocation = null;
    } on OpenWeatherAPIException catch (e) {
      if (e == 'OpenWeatherAPIException') {
        print("e.message ${e}");
        print('Invalid API key.');
        setState(() {
          countryName ="";
          subAdminArea = "";
          weather = "";
        });
      }
    }
  }
}
