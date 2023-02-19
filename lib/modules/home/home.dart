import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shahed/modules/home/dashboard/dashboard.dart';
import 'package:shahed/modules/home/responses/map_respo.dart';
import 'package:shahed/modules/home/tracking/BrowserMap.dart';
import 'package:shahed/provider/counter_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:shahed/widgets/custom_drawer.dart';
import 'package:shahed/widgets/custom_indecator.dart';
import 'package:weather/weather.dart' as we;
import 'package:weather/weather.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import '../../main.dart';

import '../../widgets/customScaffoldMessenger.dart';

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
  Box? box;

  var provider;
  double  latitude=0.0, long =0.0;
  List? points;
  String? titleNotification;
  bool? _isMoving;
  bool? _enabled;
  String? motionActivity;
  String? odometer;
  String? content;
  String? routeName = '';
  String? apiPath = 'http://ets.ly/api/update_position';

  @pragma('vm:entry-point')
  void openPage(var ro,
      {double? lat, lng, List? path_coordinates = null, String? route = null}) {


    if (route == null) {
      route = routeName!;
    }
    if (route != null) {
      if (route == 'missionWithPath' || route == "mission") {
        if (path_coordinates == null) {
          path_coordinates = points;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowserMap(
              latLngDestination: LatLng(
                  lat == null ? latitude  : lat, lng == null ? long : lng),
              state: 1,
              path: path_coordinates!,
              pathshasData: path_coordinates.length > 0 ? 'yes' : '',
            ),
          ),
        );
      }
      if (route == 'RespondToEvent') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Mappoly(
                  lat: lat  == null ? latitude  : lat ,
                  lng: lng  == null ? long  : lng )),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState(); //_getUserLocation();
    _isMoving = false;
    _enabled = false;
    content = '';
    motionActivity = 'UNKNOWN';
    odometer = '0';
    openBox();
     startTrip();

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid,iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: openPage); // foreground notification
    // foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message!.notification!;
      AndroidNotification android = message!.notification!.android!;

      if (notification != null && android != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);

        routeName = message.data['route'];
        var provider = Provider.of<CounterProvider>(context , listen: false);
        if ((message.data['route'] == 'missionWithPath' )|| (message.data['route'] == "mission")) {
          provider.setCounterMissions=true;
        }else{
          provider.setCounterNotification=true;
        }
// if theres problem i will check this code below
      if(mounted){
        setState(() {
          latitude = routeName == 'RespondToEvent'
              ? double.parse(message.data['lat'])
              : double.parse(message.data['lat_f']);
          long = routeName == 'RespondToEvent'
              ? double.parse(message.data['lng'])
              : double.parse(message.data['lng_f']);
          points = routeName == 'RespondToEvent'
              ? []
              : jsonDecode(message.data['path_cordinates']);
        });
      }

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
              iOS: DarwinNotificationDetails()
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message!.notification!;
      AndroidNotification android = message!.notification!.android!;
      if (notification != null && android != null) {
        var provider = Provider.of<CounterProvider>(context ,listen: false);
        if (message.data['route'] == 'missionWithPath' || message.data['route'] == "mission") {
          provider.setCounterMissions=true;
        }else{
          provider.setCounterNotification=true;
        }
        openPage("",
            lat: message.data['route'] == 'RespondToEvent'
                ? double.parse(message.data['lat'])
                : double.parse(message.data['lat_f']),
            lng: message.data['route'] == 'RespondToEvent'
                ? double.parse(message.data['lng'])
                : double.parse(message.data['lng_f']),
            path_coordinates: message.data['route'] == 'RespondToEvent'
                ? []
                : jsonDecode(message.data['path_cordinates']),
            route: message.data['route']);
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('TERMINATED');
        var provider = Provider.of<CounterProvider>(context ,listen: false);
        if (message.data['route'] == 'missionWithPath' || message.data['route'] == "mission") {
          provider.setCounterMissions=true;
        }else{
          provider.setCounterNotification=true;
        }
        openPage("",
            lat: message.data['route'] == 'RespondToEvent'
                ? double.parse(message.data['lat'])
                : double.parse(message.data['lat_f']),
            lng: message.data['route'] == 'RespondToEvent'
                ? double.parse(message.data['lng'])
                : double.parse(message.data['lng_f']),
            path_coordinates: message.data['route'] == 'RespondToEvent'
                ? []
                : jsonDecode(message.data['path_cordinates']),
            route: message.data['route']);
      }
    });

  }

  startTrip() async {
    final storage = await SharedClass.getStorage();
    String? token = await storage.read(
        key: "token", aOptions: SharedClass.getAndroidOptions());
    SharedClass.getBox().then((UserInfo) async {
      if(SharedData.getUserState()){
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

        bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 5,
            locationTemplate:
            '{"lat":<%= latitude %>,"lng":<%= longitude %>,"time":"<%= timestamp %>","speed":<%= speed %>,"accuracy":<%= accuracy %>}',
            url: '$apiPath',
            method: 'POST',
            httpRootProperty: '.',
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
            stopOnTerminate: false,
            startOnBoot: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            reset: true))
            .then((bg.State state) {
          //    _getUserLocation();
          //if(mounted)
        //  setState(() {
            _enabled = state.enabled;
            _isMoving = state.isMoving;
        //  });
        });

      } });

  }

  void _onClickEnable(enabled) {
    customScaffoldMessenger(
        color: Colors.orange,
        context: context,
        seconds: 2,
        text: SharedData.getGlobalLang().waitMessage());
    if (enabled) {
      bg.BackgroundGeolocation.start().then((bg.State state) {
        SharedClass.getBGState(state: state.enabled);
        print('[start] success $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      });
    } else {
      bg.BackgroundGeolocation.stop().then((bg.State state) {
        SharedClass.getBGState(state: state.enabled);
        print('[stop] success: $state');
        // Reset odometer.
        SharedClass.getBox().then((UserInfo) async {
          print('[stop] success: $state');
          await Provider.of<EventProvider>(context, listen: false).stopTracking(
              UserInfo.get('user_id'),
              int.parse(UserInfo.get('beneficiarie_id')));
          // Reset odometer.
        });
        bg.BackgroundGeolocation.setOdometer(0.0);

        setState(() {
          odometer = '0.0';
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      });
    }
  }

  // Manually toggle the tracking state:  moving vs stationary
  void _onClickChangePace() {
    setState(() {
      _isMoving = !_isMoving!;
    });
    print("[onClickChangePace] -> $_isMoving");

    bg.BackgroundGeolocation.changePace(_isMoving!).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });
  }

  void _onLocation(bg.Location location) async{
    print('[location] - $location');

    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
    if(mounted)
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
  Scaffold build(BuildContext context)   {
    return Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: false,
        appBar: customAppBar(
          context,
          title: SharedData.getGlobalLang().WitnessApp(),
          icon: FontAwesomeIcons.house,
          actions: [
             SharedData.getUserState()  == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                      scale: 1.5,
                      child: Switch(
                          activeColor: Colors.redAccent,
                          value: _enabled!,
                          onChanged: _onClickEnable),
                    ),
                  )
                : SizedBox.shrink(),
            SharedData.getUserState() == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        minWidth: 30.0,
                        child: Icon(FontAwesomeIcons.personWalking,
                            color: Colors.white),
                        color: (_isMoving!) ? Colors.red : Colors.green,
                        onPressed: _onClickChangePace),
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
                                " ${SharedData.getGlobalLang().Hello()} ${box!.get('unitname')}!",
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

  _getUserLocation(double latitude,longitude) async {

    String error;
    try {
      we.WeatherFactory wf = SharedClass.getWeatherFactory();
      we.Weather w = await wf.currentWeatherByLocation(
          latitude,longitude);

      GeoData result = await Geocoder2.getDataFromCoordinates(
              latitude:  latitude,
              longitude:  longitude,
              googleMapApiKey: "${SharedClass.mapApiKey}")
          .catchError((onError) {
        print(onError);
      });
      setState(() {
        countryName = result.country;
        subAdminArea = result.address;
        weather = w.temperature!.celsius!.toInt().toString();
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
