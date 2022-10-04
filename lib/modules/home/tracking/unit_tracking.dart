import 'dart:async';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as p;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/unit.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/customPopupMenuEntry.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_dialog.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:weather/weather.dart';
import '../../../widgets/custom_indecator.dart';

class UnitTracking extends StatefulWidget {
  const UnitTracking({Key key}) : super(key: key);

  @override
  State<UnitTracking> createState() => _UnitTrackingState();
}

class _UnitTrackingState extends State<UnitTracking> {
  StreamSubscription _locationSubscription;
  final kGoogleApiKey = SharedClass.mapApiKey;
  geo.LocationAccuracy desiredAccuracy = geo.LocationAccuracy.best;
  GoogleMapsPlaces _places;
  bool active = false;

  // Location _locationTracker = Location();
  Marker marker, _destination;
  Map data;
  MapType maptype = MapType.satellite;
  geo.Position currentPosition;
  Timer timer;
  DateTime oldTime, newTime;
  Circle circle;
  Completer<GoogleMapController> _controller = Completer();
  int senderID;
  int beneficiarie_id;
  double _lat_startpoint, _lng_startpoint, _lat_endpoint, _lng_endpoint;
  bool traffic = false;
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
    if (_lng_endpoint != null) _getPolyline(_lat_endpoint, _lng_endpoint);
  }

  Future<void> getIniLocation() async {
    try {
      final GoogleMapController controller = await _controller.future;
      Uint8List imageData = await getMarker();
      //   var location = await _locationTracker.getLocation();
      geo.Position position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: desiredAccuracy);
      print("getIniLocation  position lat ${position.latitude}");
      print("getIniLocation position _lng  ${position.longitude}");
      updateMarkerAndCircle(position, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _lat_startpoint = position.latitude;
      _lng_startpoint = position.longitude;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    SharedClass.getTrackingBox().then((value) => null);
    SharedClass.getBox().then((getValue) {
      mygetCurrentPosition().then((value) {
        setState(() {
          senderID = getValue.get('user_id');
          beneficiarie_id = int.parse(getValue.get('beneficiarie_id'));
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
    SharedClass.closeTracking();
    timer?.cancel();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    Wakelock.disable();
  }

  Future<void> _sendLiveLocation() async {
    var boxTracking = await SharedClass.getTrackingBox();
    // var location = await _locationTracker.getLocation();
    geo.Position pos = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy);
    _newLatitude = pos.latitude;
    _newLongitude = pos.longitude;
    double cu_lat = _newLatitude, cu_long = _newLongitude;

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
      double totalHours =
          ((minutes * 60) + seconds + (newTime.hour * 3600)) / 3600.0;

      //var location = await _locationTracker.getLocation();
      // geo.Position location = await geo.Geolocator.getCurrentPosition(
      //     desiredAccuracy: desiredAccuracy);
      data = {
        'sender_id': senderID.toString(),
        'beneficiarie_id': beneficiarie_id.toString(),
        'lat': cu_lat.toString(),
        'lng': cu_long.toString(),
        'distance': distance.toString(),
        'lat_startpoint': _lat_startpoint.toString(),
        'lng_startpoint': _lng_startpoint.toString(),
        'lat_endpoint': _lat_endpoint.toString(),
        'lng_endpoint': _lng_endpoint.toString(),
        'time': totalHours
      };

      checkInternetConnectivity(context).then((bool value) async {
        if (distance > 4.0) //distance > 4
        {
          print("distance: ${distance}");
          if (value) // phone is connected ...
          {
            await syncData().then((value) {
              Provider.of<EventProvider>(context, listen: false)
                  .update_position(data);
            }); // for sync local data

          } else {
            boxTracking.add(Tracking(
                senderID: senderID,
                beneficiarieID: beneficiarie_id,
                lat: cu_lat,
                lng: cu_long,
                distance: distance,
                latStartPoint: _lat_startpoint,
                lngStartPoint: _lng_startpoint,
                latEndPoint: _lat_endpoint,
                lngEndPoint: _lng_endpoint,
                time: totalHours));
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

  String weather = "";
  p.PolylinePoints polylinePoints = p.PolylinePoints();

  handleTap(LatLng tappedPoint) async {
    WeatherFactory wf = SharedClass.getWeatherFactory();
    Weather w = await wf.currentWeatherByLocation(
        tappedPoint.latitude, tappedPoint.longitude);
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: tappedPoint.latitude,
        longitude: tappedPoint.longitude,
        googleMapApiKey: SharedClass.mapApiKey.toString());
    setState(() {
      weather = w.temperature.celsius.toInt().toString();
      _lat_endpoint = tappedPoint.latitude;
      _lng_endpoint = tappedPoint.longitude;
      _destination = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        markerId: MarkerId(521.toString()),
        position: tappedPoint,
        infoWindow: InfoWindow(
          title: "${data.address}",
          snippet: "${data.state}",
        ),
      );
    });
    _getPolyline(tappedPoint.latitude, tappedPoint.longitude);


    //var location = await _locationTracker.getLocation();
    geo.Position location2 = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy);
    _oldLatitude = location2.latitude;
    _oldLongitude = location2.longitude;
    print("handleTap  _oldLatitude lat ${_oldLatitude}");
    print("handleTap _oldLongitude _lng  ${_oldLongitude}");
    oldTime = DateTime.now();
    if(active==false)
      showShortToast( SharedData.getGlobalLang() .mustEnableTracking(), Colors.orangeAccent);

    print("the distance is :"
        "${vincentyGreatCircleDistance(_oldLatitude , _oldLongitude , _lat_endpoint,_lng_startpoint)}");
  }
  // double calculateDistances(lat1, lon1, lat2, lon2){
  //   var p = 0.017453292519943295;
  //   var a = 0.5 - cos((lat2 - lat1) * p)/2 +
  //       cos(lat1 * p) * cos(lat2 * p) *
  //           (1 - cos((lon2 - lon1) * p))/2;
  //   return 12742 * asin(sqrt(a));
  // }
  Map<PolylineId, Polyline> polylines = {};

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId(
      "poly",
    );
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 6,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  Map<MarkerId, Marker> markers = {};

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _getPolyline(var lat, var long) async {
    /// add origin marker origin marker
    var currentPosition = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy);
    _addMarker(
      LatLng(currentPosition.latitude, currentPosition.longitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(lat, long),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );
    List<LatLng> polylineCoordinates = [];

    p.PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "${SharedClass.mapApiKey}",
      p.PointLatLng(currentPosition.latitude, currentPosition.longitude),
      p.PointLatLng(lat, long),
      travelMode: p.TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((p.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  double getDistance(double lat1, lon1, lat2, lon2) {
    var R = 6378137; // Earth’s mean radius in meter
    var dLat = rad(lat2 - lat1);
    var dLong = rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(rad(lat1)) * cos(rad(lat2)) * sin(dLong / 2) * sin(dLong / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = R * c;
    return distance; // returns the distance in meter
  }

  double rad(final double degrees) => (degrees * pi / 180.0);

  Future mygetCurrentPosition() async {
    currentPosition = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy);
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

    var distance =
        getDistance(oldLatitude, oldLongitude, newLatitude, newLongitude);
    print("distance before check: $distance");
    return distance;
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      print("p is not null ");

      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      // var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: SharedData.getGlobalLang().trackingUnit(),
          icon: Icons.track_changes,
          actions: [
            IconButton(
              onPressed: () {
                customReusableShowDialog(
                  context,
                  SharedData.getGlobalLang().headOfTrackAlert(),
                  widget: Text(SharedData.getGlobalLang().bodyOfTrackAlert()),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        SharedData.getGlobalLang().cancel(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextButton(
                        child: Text(
                          active == false
                              ? SharedData.getGlobalLang().enable()
                              : SharedData.getGlobalLang().disable(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: () {
                          if (active == false) {
                            if (_lng_endpoint != null) {
                              setState(() {
                                active = !active;
                              });
                              showShortToast(
                                  SharedData.getGlobalLang()
                                      .activatedSuccessfully(),
                                  Colors.green);

                              //  timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _sendLiveLocation());
                            } else {
                              showShortToast(
                                  SharedData.getGlobalLang().selectDestination(),
                                  Colors.orangeAccent);
                            }
                          } else {
                            showShortToast(
                                SharedData.getGlobalLang()
                                    .deactivatedSuccessfully(),
                                Colors.green);
                            setState(() {
                              active = !active;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                );
              },
              icon: Icon(
                active == false ? Icons.gps_not_fixed : Icons.gps_fixed,
                color: active == false ? Colors.grey : Colors.red,
              ),tooltip: SharedData.getGlobalLang().enableTrackingUnit(),
            )
          ],
          leading: PopupMenuButton(
            icon: Icon(Icons.layers),
            itemBuilder: (builder) {
              return customPopupMenuEntry();
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  setState(() {
                    maptype = MapType.hybrid;
                  });
                  break;
                case 1:
                  setState(() {
                    maptype = MapType.normal;
                  });
                  break;
                case 2:
                  setState(() {
                    maptype = MapType.satellite;
                  });
                  break;
                case 3:
                  setState(() {
                    maptype = MapType.terrain;
                  });
                  break;
              }
            },
          ),
        ),
        body: _kGooglePlex == null
            ? Container(child: Center(child: customCircularProgressIndicator()))
            : Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    trafficEnabled: traffic,
                    myLocationEnabled: true,
                    onTap: handleTap,
                    onLongPress: (val) {
                      setState(() {
                        polylines.clear();
                        _lng_endpoint=null;
                        _lat_endpoint=null;
                        _destination = null;
                      });
                    },
                    myLocationButtonEnabled: false,
                    mapType: maptype,
                    initialCameraPosition: _kGooglePlex,
                    polylines: Set<Polyline>.of(polylines.values),
                    // markers: Set<Marker>.of(markers.values),
                    markers: {
                      if (marker != null) marker,
                      if (_destination != null) _destination
                    },
                    //   circles: Set.of((circle != null) ? [circle] : []),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMoveStarted: () async {
                      //   _locationSubscription.cancel();
                      Uint8List imageData = await getMarker();
                      geo.Position position =
                          await geo.Geolocator.getCurrentPosition(
                              desiredAccuracy: desiredAccuracy);
                      updateMarkerAndCircle(position, imageData);
                    },

                    onCameraMove: (value) async {
                      // if(_locationSubscription!=null)
                      // _locationSubscription.cancel();
                      // Uint8List imageData = await getMarker();
                      // geo.Position position = await geo.Geolocator.getCurrentPosition(
                      //     desiredAccuracy:desiredAccuracy);
                      //   updateMarkerAndCircle(position, imageData);
                    },
                  ),
                  Positioned(
                      child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                         children: [
                          IconButton(
                            tooltip: SharedData.getGlobalLang().back(),
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              // if active is true then we need show alert to the user to check
                              Navigator.pop(context);
                            },
                          ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.temperatureThreeQuarters,
                                color: Colors.yellow,
                                size: 24,
                              ),

                              Text(
                                "${weather}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final GoogleMapController controller =
                                  await _controller.future;
                              String location = "Search Location";
                              var place = await PlacesAutocomplete.show(
                                  context: context,
                                  apiKey: kGoogleApiKey,
                                  mode: Mode.overlay,
                                  hint: SharedData.getGlobalLang().search(),
                                  types: [],
                                  strictbounds: false,
                                  components: [
                                    Component(Component.country, 'ly'),
                                  ],
                                  //google_map_webservice package
                                  onError: (err) {
                                    print(err);
                                  });

                              if (place != null) {
                                setState(() {
                                  location = place.description.toString();
                                });

                                //form google_maps_webservice package
                                final plist = GoogleMapsPlaces(
                                  apiKey: kGoogleApiKey,
                                  apiHeaders:
                                      await GoogleApiHeaders().getHeaders(),
                                  //from google_api_headers package
                                );
                                String placeid = place.placeId ?? "0";
                                final detail = await plist.getDetailsByPlaceId(placeid);
                                final geometry = detail.result.geometry;
                                var newlatlang = LatLng(geometry.location.lat,  geometry.location.lng);
                                if (_locationSubscription != null)
                                  _locationSubscription.cancel();
                                //move map camera to selected place with animation
                                controller.animateCamera(
                                    CameraUpdate.newCameraPosition(CameraPosition(
                                        target: newlatlang, zoom: 17)));
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.black12.withOpacity(.5),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), //<-- SEE HERE
                            padding: EdgeInsets.all(10),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              traffic = !traffic;
                            });
                          },
                          child: Icon(
                            FontAwesomeIcons.bus,
                            color: traffic == true
                                ? Colors.green
                                : Colors.black54.withOpacity(.5),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), //<-- SEE HERE
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                        PopupMenuButton(
                          tooltip: SharedData.getGlobalLang().GPSAccuracy(),
                          icon: Icon(
                            Icons.pin_drop_rounded,
                            size: 28,
                          ),
                          itemBuilder: (builder) {
                            return customPopupMenuEntry(
                                low: SharedData.getGlobalLang().lowAccuracy(),
                                medium:
                                    SharedData.getGlobalLang().mediumAccuracy(),
                                high: SharedData.getGlobalLang().highAccuracy(),
                                best: SharedData.getGlobalLang().bestAccuracy());
                          },
                          onSelected: (value) {
                            switch (value) {
                              case 0:
                                setState(() {
                                  desiredAccuracy = geo.LocationAccuracy.low;
                                });
                                break;
                              case 1:
                                setState(() {
                                  desiredAccuracy = geo.LocationAccuracy.medium;
                                });
                                break;
                              case 2:
                                setState(() {
                                  desiredAccuracy = geo.LocationAccuracy.high;
                                });
                                break;
                              case 3:
                                setState(() {
                                  desiredAccuracy = geo.LocationAccuracy.best;
                                });
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  )),
                ],
              ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.location_searching,
              color: Colors.black12.withOpacity(.5),
            ),
            tooltip: SharedData.getGlobalLang().currentLocation(),
            backgroundColor: Colors.deepOrange,
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              Uint8List imageData = await getMarker();
              geo.Position position = await geo.Geolocator.getCurrentPosition(
                  desiredAccuracy: desiredAccuracy);
              updateMarkerAndCircle(position, imageData);

              if (_locationSubscription != null) {
                _locationSubscription.cancel();
              }
              final geo.LocationSettings locationSettings = geo.LocationSettings(
                accuracy: desiredAccuracy,
                distanceFilter: 0,
              );
              //    geo.Position  position = await geo.Geolocator.getCurrentPosition(desiredAccuracy: desiredAccuracy);

              _locationSubscription = geo.Geolocator.getPositionStream(
                      locationSettings: locationSettings)
                  .listen((geo.Position position) {
                if (controller != null) {
                  _lat_startpoint = position.latitude;
                  _lng_startpoint = position.longitude;
                  print("FloatingActionButton _lat_startpoint $_lat_startpoint");
                  print("FloatingActionButton _lng_startpoint $_lng_startpoint");

                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          //bearing: 0,
                          target: LatLng(position.latitude, position.longitude),
                          // tilt: 0,
                          zoom: 18.0)));
                  updateMarkerAndCircle(position, imageData);
                  //  print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
                }
              });
            }),
      ),
    );
  }

  Future<bool> syncData() async {
    SharedClass.getTrackingBox().then((boxTracking) {
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
    });
  }
}
