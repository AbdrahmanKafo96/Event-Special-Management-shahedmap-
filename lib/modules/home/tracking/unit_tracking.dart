import 'dart:async';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_circle_distance_calculator/great_circle_distance_calculator.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/models/unit.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:systemevents/widgets/custom_app_bar.dart';

class UnitTracking extends StatefulWidget {
  const UnitTracking({Key key}) : super(key: key);

  @override
  State<UnitTracking> createState() => _UnitTrackingState();
}

class _UnitTrackingState extends State<UnitTracking> {
  StreamSubscription _locationSubscription;
  // Location _locationTracker = Location();
  Marker marker, _destination;
  Map data;
  geo.Position currentPosition;
  Timer timer;
  DateTime oldTime, newTime;
  Circle circle;
  Completer<GoogleMapController> _controller = Completer();

  double _lat_startpoint, _lng_startpoint, _lat_endpoint, _lng_endpoint;

  double _oldLatitude, _oldLongitude, _newLatitude, _newLongitude;

  static CameraPosition _kGooglePlex;

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/icons/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(geo.Position newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blueAccent,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  Future<void> getIniLocation() async {
    try {
      final GoogleMapController controller = await _controller.future;
      Uint8List imageData = await getMarker();
   //   var location = await _locationTracker.getLocation();
      geo.Position  position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      print("getIniLocation  position lat ${position.latitude}");
      print("getIniLocation position _lng  ${position.longitude}");
      updateMarkerAndCircle(position, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      // _locationSubscription =
      //     _locationTracker.onLocationChanged.listen((newLocalData) {
      //   if (controller != null) {
      //     _lat_startpoint = location.latitude;
      //     _lng_startpoint = location.longitude;
      //
      //     controller
      //         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //             //bearing: 0,
      //             target: LatLng(newLocalData.latitude, newLocalData.longitude),
      //             // tilt: 0,
      //             zoom: 18.0)));
      //     updateMarkerAndCircle(newLocalData, imageData);
      //   }
      // });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  int senderID;

  @override
  void initState() {
    super.initState();

      Singleton.getTrackingBox().then((value) => null);
    print("database is opened ");
    Singleton.getBox().then((getValue) {
      getCurrentPosition().then((value) {
        setState(() {
          senderID = getValue.get('user_id');
          _kGooglePlex = CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 18,
          );
          getIniLocation();
        });
        return value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _kGooglePlex = null;
    Singleton.closeTracking();
    timer?.cancel();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
  }

  Future<void> _sendLiveLocation() async {
    var boxTracking = await Singleton.getTrackingBox();
    // var location = await _locationTracker.getLocation();
    geo.Position  pos = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    _newLatitude = pos.latitude;
    _newLongitude = pos.longitude;
    print("_sendLiveLocation  _newLatitude lat ${_newLatitude }");
    print("_sendLiveLocation _newLongitude _lng  ${_newLongitude  }");
    if (_oldLatitude != null &&
        _oldLongitude != null &&
        _newLatitude != null &&
        _newLongitude != null) {
      double distance = vincentyGreatCircleDistance(
          _oldLatitude, _oldLongitude, _newLatitude, _newLongitude);

      newTime = DateTime.now();
      int minutes = newTime.minute - oldTime.minute;
      int seconds = newTime.second - oldTime.second;

      if (minutes < 0) minutes *= -1;

      if (seconds < 0) seconds *= -1;

      double totalHours = ((minutes * 60) + seconds + (newTime.hour * 3600)) /
          3600.0; // convert time to hours
      //var location = await _locationTracker.getLocation();
      geo.Position  location = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      data = {
        'sender_id': senderID.toString(),
        'beneficiarie_id': 2.toString(), // ok we will do it soon
        'lat': location.latitude.toString(),
        'lng': location.longitude.toString(),
        'distance': distance.toString(),
        'lat_startpoint': _lat_startpoint.toString(),
        'lng_startpoint': _lng_startpoint.toString(),
        'lat_endpoint': _lat_endpoint.toString(),
        'lng_endpoint': _lng_endpoint.toString(),
        'time': totalHours
      };

      checkInternetConnectivity(context).then((bool value) async {
        if (true) //distance > 4
        {
          if (value) // phone is connected ...
          {
            await syncData().then((value) {
              print("now its time to upload data");
              Provider.of<EventProvider>(context, listen: false)
                  .update_position(data);
            }); // for sync local data

          } else {
            boxTracking.add(Tracking(
                senderID: senderID,
                beneficiarieID:2,
                lat: location.latitude,
                lng: location.longitude,
                distance: distance,
                latStartPoint: _lat_startpoint,
                lngStartPoint: _lng_startpoint,
                latEndPoint: _lat_endpoint,
                lngEndPoint: _lng_endpoint,
                time: totalHours));
            print("item is saved in local database ");
          }
        }
      });

      setState(() {
        _oldLatitude = _newLatitude;
        _oldLongitude = _newLongitude;
        oldTime = newTime;
      });
      // send data to the api...

    } else {
      print("this first call");
    }
  }

  handleTap(LatLng tappedPoint) async {
    setState(() {
      _destination = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        markerId: MarkerId(521.toString()),
        position: tappedPoint,
      );
    });
    _lat_endpoint = _destination.position.latitude;
    _lng_endpoint = _destination.position.longitude;

   //var location = await _locationTracker.getLocation();
    geo.Position  location = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      _oldLatitude = location.latitude;
      _oldLongitude = location.longitude;
    print("handleTap  _oldLatitude lat ${_oldLatitude}");
    print("handleTap _oldLongitude _lng  ${_oldLongitude}");
      oldTime = DateTime.now();

      timer = Timer.periodic(
          Duration(seconds: 5), (Timer t) => _sendLiveLocation());

  }

  Future getCurrentPosition() async {
    currentPosition = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
    print("getCurrentPosition  position lat ${currentPosition.latitude}");
    print("getCurrentPosition position _lng  ${currentPosition.longitude}");
  }


  double vincentyGreatCircleDistance(
    double oldLatitude,
    double oldLongitude,
    double newLatitude,
    double newLongitude,
  ) {
    // convert from degrees to radians
    var gcd = GreatCircleDistance.fromDegrees(
        latitude1: oldLatitude,
        longitude1: oldLongitude,
        latitude2: newLatitude,
        longitude2: newLongitude);

    return gcd.sphericalLawOfCosinesDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar( 
        title: "تتبع الوحدة" ,
        icon: Icons.track_changes
      ),
      body: _kGooglePlex == null
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
              color: Colors.green,
            )))
          : GoogleMap(
              myLocationEnabled: true,
              onTap: handleTap,
              onLongPress: (val) {
                setState(() {
                  _destination = null;
                });
              },
              myLocationButtonEnabled: false,
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              markers: {
                if (marker != null) marker,
                if (_destination != null) _destination
              },
              //   circles: Set.of((circle != null) ? [circle] : []),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: ()    async {
            final GoogleMapController controller = await _controller.future;
            Uint8List imageData = await getMarker();
           // var location = await _locationTracker.getLocation();
            geo.Position  position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
            updateMarkerAndCircle(position, imageData);

            if (_locationSubscription != null) {
              _locationSubscription.cancel();
            }
            final geo.LocationSettings locationSettings = geo.LocationSettings(
              accuracy: geo.LocationAccuracy.high,
              distanceFilter: 100,
            );
         //    geo.Position  position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

            _locationSubscription   = geo.Geolocator.getPositionStream(locationSettings: locationSettings).listen(
                    (geo.Position  position) {
                    if (controller != null) {
                    _lat_startpoint = position.latitude;
                    _lng_startpoint = position.longitude;
                      print("FloatingActionButton _lat_startpoint $_lat_startpoint");
                      print("FloatingActionButton _lng_startpoint $_lng_startpoint");
                    controller
                        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    //bearing: 0,
                    target: LatLng(position.latitude, position.longitude),
                    // tilt: 0,
                    zoom: 18.0)));
                    updateMarkerAndCircle(position, imageData);
                //  print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
                }});
            //     _locationTracker.onLocationChanged.listen((  newLocalData) {

            //   }
            // });
           // getCurrentLocation();
           // //  final GoogleMapController controller = await _controller.future;
           // //  LocationData currentLocation;
           // //  var location = new Location();
           // //  try {
           // //    currentLocation = await location.getLocation();
           // //  } on Exception {
           // //    currentLocation = null;
           // //  }
           // //
           // //  controller.animateCamera(CameraUpdate.newCameraPosition(
           // //    CameraPosition(
           // //      bearing: 0,
           // //      target: LatLng(currentLocation.latitude, currentLocation.longitude),
           // //      zoom: 15.0,
           // //    ),
           // //  ));
          }),
    );
  }

  Future<bool> syncData() async {
      Singleton.getTrackingBox().then((boxTracking){
        print("database local is open ");

        Tracking tracking;
        if (boxTracking.length == 0) {
          print("there is no data to sync ");
        }
        if (boxTracking.length > 0) {
          for (int i = 0; i < boxTracking.length; i++) {
            tracking = boxTracking.getAt(i);

            Map data = {
              'sender_id': tracking.senderID.toString(),
              'beneficiarie_id': tracking.beneficiarieID.toString(),
              'lat': tracking.lat.toString(),
              'lng': tracking.lng.toString(),
              'distance': tracking.distance.toString(),
              'lat_startpoint': tracking.latStartPoint.toString(),
              'lng_startpoint': tracking.lngStartPoint.toString(),
              'lat_endpoint': tracking.latEndPoint.toString(),
              'lng_endpoint': tracking.lngEndPoint.toString(),
              'time': tracking.time.toString()
            };
            print("local item is sent ...");
            Provider.of<EventProvider>(context, listen: false)
                .update_position(data);
          }
          boxTracking.clear();
        }
        return true;
      } );

  }
}
