import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/event.dart';
import 'dart:convert';
import 'package:shahed/modules/home/dashboard/dashboard.dart';
import 'package:shahed/modules/home/event_screens/main_section.dart';
import 'package:shahed/modules/home/tracking/BrowserMap.dart';
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
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import '../../main.dart';
import 'dart:math';
JsonEncoder encoder = JsonEncoder.withIndent("     ");
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
  Box box  ;
  var provider;
  double latitude, long;
  List points;
  String titleNotification;
  bool  isMoving;
  bool _enabled;
  String  motionActivity;
  String  odometer;
  String content;
  String  routeName='';

  @pragma('vm:entry-point')
  void openPage(var ro,
      {double lat, lng,  List path_coordinates = null ,String route=null}) {
    // {route: missionWithPath, lat_f: 32.893485, lng_f: 13.249322, lat_s: 32.893485, lng_s: 13.249322,
    // path_cordinates: [{"lat":32.893485,"long":13.249322},{"lat":32.855423,"long":13.204346},
    // {"lat":32.881088,"long":13.167954},{"lat":32.893485,"long":13.249322}]}

      if(route==null){
        route=routeName;
        if(route=='missionWithPath' || route=="mission"){
          if (path_coordinates == null) {
            path_coordinates = points;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrowserMap(
                latLngDestination: LatLng(
                    lat == null ? latitude : lat, lng == null ? long : lng) ,state: 1,
                path: path_coordinates ,pathshasData:path_coordinates.length>0? 'yes':'',),
            ),
          );
        }
      }
  }

  @override
  void initState() {
    super.initState();
    isMoving = false;
    _enabled = false;
    content = '';
    motionActivity = 'UNKNOWN';
    odometer = '0';
    openBox();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: openPage);// foreground notification
    // foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        print(message.notification.title);
        print(message.notification.body);
        print(message.data);

        setState(() {
          latitude = double.parse(message.data['lat_f']);
          long = double.parse(message.data['lng_f']);
          points = jsonDecode(message.data['path_cordinates']);
          routeName = message.data['route'];
        });

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
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        openPage("",
            lat: double.parse(message.data['lat_f']),
            lng: double.parse(message.data['lng_f']),
            path_coordinates: jsonDecode(message.data['path_cordinates']),
            route: message.data['route']
        );
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('TERMINATED');
        openPage("",
            lat: double.parse(message.data['lat_f']),
            lng: double.parse(message.data['lng_f']),
            path_coordinates: jsonDecode(message.data['path_cordinates'],),
            route: message.data['route']
        );
      }
    });
   _getUserLocation();
    startTrip();
  }

  startTrip() async {
    final storage = await SharedClass.getStorage();
    String token = await storage.read(
        key: "token", aOptions: SharedClass.getAndroidOptions());
    SharedClass.getBox().then((UserInfo) async {
      // 1.  Listen to events (See docs for all 12 available events).
      bg.BackgroundGeolocation.onLocation(_onLocation);
      bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
      bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
      bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
      bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

      bg.BackgroundGeolocation.onHttp((response) {
        print(
            "[http] response:   ${response.success}, ${response.status}, ${response.responseText}");
      });

      // 2.  Configure the plugin
      bg.BackgroundGeolocation.ready(bg.Config(
              desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
              distanceFilter: 10,
              isMoving: true,
              forceReloadOnGeofence: true,
              forceReloadOnSchedule: true,
              stopOnTerminate: false,
              method: 'post',
              foregroundService: true,
              httpRootProperty: '.',
              enableHeadless: true,
              locationTemplate: '{"lat":<%= latitude %>,"lng":<%= longitude %>,"time":"<%= timestamp %>",speed:<%= speed %>}',
              url: 'http://ets.ly/api/update_position',
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
                'content-type': 'application/json',
              },
              params: {
                'sender_id': UserInfo.get('user_id'),
                'beneficiarie_id': int.parse(UserInfo.get('beneficiarie_id')),
                'distance': 10,
              },
              autoSync: true,
              //batchSync: true,
            maxDaysToPersist: 1,
              startOnBoot: true,
              forceReloadOnBoot: true,
              stopTimeout: 10,
              //  stationaryRadius: ,
              debug: true,
              logLevel: bg.Config.LOG_LEVEL_VERBOSE,
              reset: true))
          .then((bg.State state) {
        setState(() {
          _enabled = state.enabled;
          //  _isMoving = state.isMoving;
        });
      });
    });
  }

// ---------- not this method --------------
  void _onClickEnable(enabled) {

    SharedClass.getBox().then((UserInfo) async {
      if (enabled) {
        bg.BackgroundGeolocation.start().then((bg.State state) {
          print('[start] success $state');
          bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
            print('[changePace] success $isMoving.');
          }).catchError((e) {
            print('[changePace] ERROR: ' + e.code.toString());
          });
          setState(() {
            _enabled = state.enabled;
            // _isMoving = state.isMoving;
          });
        });
      } else {
        bg.BackgroundGeolocation.stop().then((bg.State state) async {
          print('[stop] success: $state');
          await Provider.of<EventProvider>(context, listen: false).stopTracking(
              UserInfo.get('user_id'),
              int.parse(UserInfo.get('beneficiarie_id')));
          // Reset odometer.
          bg.BackgroundGeolocation.setOdometer(0.0);

          setState(() {
            //_odometer = '0.0';
            _enabled = state.enabled;
            //  _isMoving = state.isMoving;
          });
        });
      }
    });
  }

  // ---------- not this method --------------
  // Manually toggle the tracking state:  moving vs stationary
  // void _onClickChangePace() {
  //   setState(() {
  //     //  _isMoving = !_isMoving!;
  //   });
  //   // print("[onClickChangePace] -> $_isMoving");
  //
  //   bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
  //     print('[changePace] success $isMoving.');
  //   }).catchError((e) {
  //     print('[changePace] ERROR: ' + e.code.toString());
  //   });
  // }

  // ---------- not this method --------------
  // Manually fetch the current position.

  // void _onClickGetCurrentPosition() async {
  //   bg.BackgroundGeolocation.getCurrentPosition(
  //           persist: false, // <-- do not persist this location
  //           desiredAccuracy: 0, // <-- desire best possible accuracy
  //           timeout: 1000, // <-- wait 30s before giving up.
  //           samples: 3 // <-- sample 3 location before selecting best.
  //           )
  //       .then((bg.Location location) {
  //     print('[getCurrentPosition] - $location');
  //   }).catchError((error) {
  //     print('[getCurrentPosition] ERROR: $error');
  //   });
  // }

  ////
  // Event handlers
  //

  void _onLocation(bg.Location location) {
    print('[location] - $location');

    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);

    setState(() {
      content = encoder.convert(location.toMap());

      odometer = odometerKM;
    });
  }

  void _onMotionChange(bg.Location location) {
    print('[motionchange] - $location');
  }

  // ---------- not this method --------------
  void _onActivityChange(bg.ActivityChangeEvent event) {
    print('[activitychange] - $event');
    setState(() {
      motionActivity = event.activity;
    });
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    print('$event');

    setState(() {
      content = encoder.convert(event.toMap());
    });
  }

// ---------- not this method --------------
  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('$event');
  }

  void openBox() {
    SharedClass.getBox().then((userBox) {
        setState(() {
          box = userBox;
          loader = true;
        });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     checkInternetConnectivity(context).then((bool value) async {
        //       if (value) {
        //         Provider.of<EventProvider>(context, listen: false).event =
        //             Event();
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => EventSectionOne()),
        //         );
        //       }
        //     });
        //   },
        //   tooltip: SharedData.getGlobalLang().addEvent(),
        //   child: const Icon(
        //     FontAwesomeIcons.plus,
        //     color: Colors.white,
        //     size: 24,
        //   ),
        //   backgroundColor: Colors.deepOrange,
        // ),
        appBar: customAppBar(
          context,
          title: SharedData.getGlobalLang().WitnessApp(),
          icon: FontAwesomeIcons.house,
          actions: [
            SharedData.getUserState() == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Switch(
                        activeColor: Colors.redAccent,
                        value: _enabled,
                        onChanged: _onClickEnable),
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
print('my loci:${myLocation.longitude}');
      GeoData result = await Geocoder2.getDataFromCoordinates(
          latitude: myLocation.latitude,
          longitude: myLocation.longitude,
          googleMapApiKey: "${SharedClass.mapApiKey}").catchError((onError){
            print(onError);
      });
      setState(() {
        countryName = result.country;
        subAdminArea = result.address;
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
          countryName = "";
          subAdminArea = "";
          weather = "";
        });
      }
    }
  }
}
