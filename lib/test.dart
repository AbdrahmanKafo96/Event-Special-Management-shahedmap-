// import 'package:flutter/material.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
// import 'dart:convert';
// JsonEncoder encoder =   JsonEncoder.withIndent("     ");
//
// class TestClass extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return   MaterialApp(
//       title: 'BackgroundGeolocation Demo',
//       theme:   ThemeData(
//         primarySwatch: Colors.amber,
//       ),
//       home:   MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//
//   final String title='BackgroundGeolocation Demo';
//
//   @override
//   _MyHomePageState createState() =>   _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool  _isMoving;
//   bool   _enabled;
//   String  _motionActivity;
//   String  _odometer;
//   String  _content;
//
//   @override
//   void initState() {
//     _isMoving = false;
//     _enabled = false;
//     _content = '';
//     _motionActivity = 'UNKNOWN';
//     _odometer = '0';
//     var value='179|fslQ0MbRxaPfWtgxe1qmHmTCT97WgCKjLiBvvKtT';
//     // 1.  Listen to events (See docs for all 12 available events).
//     bg.BackgroundGeolocation.onLocation(_onLocation);
//     bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
//     bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
//     bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
//     bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
//
//     bg.BackgroundGeolocation.onHttp((response){
//
//       print("[http] response:   ${response.success}, ${response.status}, ${response.responseText}");
//     });
//
//     // 2.  Configure the plugin
//     bg.BackgroundGeolocation.ready(bg.Config(
//         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//         distanceFilter: 0,
//         isMoving: true,
//         forceReloadOnGeofence: true,
//         forceReloadOnSchedule: true,
//         stopOnTerminate: false,
//         method: 'post',
//         foregroundService: true,
//         httpRootProperty: '.',
//         locationTemplate: '{"lat":<%= latitude %>,"lng":<%= longitude %>,"speed":<%= speed %>}',
//         url: 'http://ets.ly/api/update_position',
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $value',
//           'content-type': 'application/json',
//         },
//         params: {
//           'sender_id':11111,
//           'beneficiarie_id':11111,
//         },
//
//         startOnBoot: true,
//         forceReloadOnBoot: true ,
//         stopTimeout:10 ,
//         //  stationaryRadius: ,
//         debug: true,
//         logLevel: bg.Config.LOG_LEVEL_VERBOSE,
//         reset: true
//     )).then((bg.State state) {
//
//       setState(() {
//         _enabled = state.enabled;
//         //  _isMoving = state.isMoving;
//       });
//     });
//   }
//
// // ---------- not this method --------------
//   void _onClickEnable(enabled) {
//     if (enabled) {
//       bg.BackgroundGeolocation.start().then((bg.State state) {
//         print('[start] success $state');
//         bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
//           print('[changePace] success $isMoving.');
//         }).catchError((e) {
//           print('[changePace] ERROR: ' + e.code.toString());
//         });
//         setState(() {
//           _enabled = state.enabled;
//           // _isMoving = state.isMoving;
//         });
//       });
//     } else {
//       bg.BackgroundGeolocation.stop().then((bg.State state) {
//         print('[stop] success: $state');
//         // Reset odometer.
//         bg.BackgroundGeolocation.setOdometer(0.0);
//
//         setState(() {
//           _odometer = '0.0';
//           _enabled = state.enabled;
//           //  _isMoving = state.isMoving;
//         });
//       });
//     }
//   }
//   // ---------- not this method --------------
//   // Manually toggle the tracking state:  moving vs stationary
//   void _onClickChangePace() {
//     setState(() {
//       //  _isMoving = !_isMoving!;
//     });
//     // print("[onClickChangePace] -> $_isMoving");
//
//     bg.BackgroundGeolocation.changePace(true).then((bool isMoving) {
//       print('[changePace] success $isMoving.');
//     }).catchError((e) {
//       print('[changePace] ERROR: ' + e.code.toString());
//     });
//   }
//
//   // ---------- not this method --------------
//   // Manually fetch the current position.
//   void _onClickGetCurrentPosition() async {
//     bg.BackgroundGeolocation.getCurrentPosition(
//         persist: false,     // <-- do not persist this location
//         desiredAccuracy: 0, // <-- desire best possible accuracy
//         timeout: 1000,     // <-- wait 30s before giving up.
//         samples: 3          // <-- sample 3 location before selecting best.
//     ).then((bg.Location location) {
//       print('[getCurrentPosition] - $location');
//     }).catchError((error) {
//       print('[getCurrentPosition] ERROR: $error');
//     });
//
//
//   }
//
//   ////
//   // Event handlers
//   //
//
//   void _onLocation(bg.Location location) {
//     print('[location] - $location');
//
//     String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
//
//     setState(() {
//       _content = encoder.convert(location.toMap());
//
//       _odometer = odometerKM;
//     });
//   }
//
//   void _onMotionChange(bg.Location location) {
//
//     print('[motionchange] - $location');
//   }
//
//   // ---------- not this method --------------
//   void _onActivityChange(bg.ActivityChangeEvent event) {
//     print('[activitychange] - $event');
//     setState(() {
//
//       _motionActivity = event.activity;
//     });
//   }
//
//   void _onProviderChange(bg.ProviderChangeEvent event) {
//     print('$event');
//
//     setState(() {
//       _content = encoder.convert(event.toMap());
//     });
//   }
//
// // ---------- not this method --------------
//   void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
//     print('$event');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text('Background Geolocation'),
//           actions: <Widget>[
//             Switch(
//                 value: _enabled ,
//                 onChanged: _onClickEnable
//             ),
//           ]
//       ),
//       body: SingleChildScrollView(
//           child: Text('$_content')
//       ),
//       bottomNavigationBar: BottomAppBar(
//           child: Container(
//               padding: const EdgeInsets.only(left: 5.0, right: 5.0),
//               child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.gps_fixed),
//                       onPressed: _onClickGetCurrentPosition,
//                     ),
//                     Text('$_motionActivity · $_odometer km'),
//                     MaterialButton(
//                         minWidth: 50.0,
//                         child: Icon((_isMoving ) ? Icons.pause : Icons.play_arrow, color: Colors.white),
//                         //  color: (_isMoving!) ? Colors.red : Colors.green,
//                         onPressed: _onClickChangePace
//                     )
//                   ]
//               )
//           )
//       ),
//     );
//   }
// }