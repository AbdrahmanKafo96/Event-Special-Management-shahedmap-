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
import 'package:shahed/models/markermodel.dart';
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
import 'package:location/location.dart' as loc;

class UnitTracking extends StatefulWidget {
  UnitTracking();

  @override
  State<UnitTracking> createState() => _UnitTrackingState();
}

class _UnitTrackingState extends State<UnitTracking>
    with WidgetsBindingObserver {
  StreamSubscription _locationSubscription;
  StreamSubscription<loc.LocationData> _locSubscription;
  final kGoogleApiKey = SharedClass.mapApiKey;
  loc.LocationAccuracy desiredAccuracy = loc.LocationAccuracy.high;
  GoogleMapsPlaces _places;
  bool active = false;
  loc.Location _locationTracker = loc.Location();
  Marker marker, _destination;

  Map data;
  MapType maptype = MapType.normal;
  loc.LocationData currentPosition;
  Timer timer;
  DateTime oldTime, newTime;
  Circle circle;
  Completer<GoogleMapController> _controller = Completer();
  int senderID;
  int beneficiarie_id;
  double _lat_startpoint, _lng_startpoint, _lat_endpoint, _lng_endpoint;
  bool traffic = false;
  double _oldLatitude, _oldLongitude, _newLatitude, _newLongitude;
  String weather = "";
  p.PolylinePoints polylinePoints = p.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  static CameraPosition _kGooglePlex;

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/icons/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      loc.LocationData newLocalData, Uint8List imageData) {
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
      markerss.add(marker);
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
      var position = await _locationTracker.getLocation();
      // geo.Position position = await geo.Geolocator.getCurrentPosition(
      //     desiredAccuracy: desiredAccuracy);

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

    WidgetsBinding.instance.addObserver(this);
    getMarkers();
    Wakelock.enable();

    _locationTracker.changeSettings(interval: 5000, accuracy: desiredAccuracy);
    _locationTracker.enableBackgroundMode(enable: true);
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    SharedClass.getTrackingBox().then((value) => null);
    SharedClass.getBox().then((getValue) {
      getCurrentPosition().then((value) {
        setState(() {
          _lat_endpoint = getValue.containsKey("lat_endpoint")
              ? getValue.get('lat_endpoint')
              : null;
          _lng_endpoint = getValue.containsKey("lng_endpoint")
              ? getValue.get('lng_endpoint')
              : null;
          active =
              getValue.containsKey("active") ? getValue.get('active') : false;
          traffic =
              getValue.containsKey("traffic") ? getValue.get('traffic') : false;
          //  _destination=getValue.containsKey("destination")?getValue.get('destination'):null;
          if (_lat_endpoint != null && _lng_endpoint != null) {
            _destination = Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              markerId: MarkerId(12.toString()),
              position: LatLng(_lat_endpoint, _lng_endpoint),
              infoWindow: InfoWindow(
                title: "last position",
                //  snippet: "${data.state}",
              ),
            );
            markerss.add(_destination);
          }
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
    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if(state== AppLifecycleState.paused || state== AppLifecycleState.inactive)
  //     _locationTracker.enableBackgroundMode(enable: true);
  //   if(state ==AppLifecycleState.resumed){
  //     _locationTracker.enableBackgroundMode(enable: false);
  //   }
  // }

  Future<void> _sendLiveLocation(BuildContext context) async {
    var boxTracking = await SharedClass.getTrackingBox();
    var pos = await _locationTracker.getLocation();
    // geo.Position pos = await geo.Geolocator.getCurrentPosition(
    //     desiredAccuracy: desiredAccuracy);
    _newLatitude = pos.latitude;
    _newLongitude = pos.longitude;
    double cu_lat = _newLatitude, cu_long = _newLongitude;

    if (_oldLatitude != null &&
        _oldLongitude != null &&
        _newLatitude != null &&
        _newLongitude != null) {
      double distance = await getDistance(LatLng(_oldLatitude, _oldLongitude),
          LatLng(_newLatitude, _newLongitude));

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
      print(data);
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
        if (distance > 5.0) //distance > 4
        {
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

      //  setState(() {
      _oldLatitude = _newLatitude;
      _oldLongitude = _newLongitude;
      oldTime = newTime;
      //  });
      // send data to the api...

    } else {
      print("start or end point is null");
    }
  }

  handleTap(LatLng tappedPoint) async {
    WeatherFactory wf = SharedClass.getWeatherFactory();
    Weather w = await wf.currentWeatherByLocation(
        tappedPoint.latitude, tappedPoint.longitude);
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: tappedPoint.latitude,
        longitude: tappedPoint.longitude,
        googleMapApiKey: SharedClass.mapApiKey.toString());
    setState(() {
      resetDestination();
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
      markerss.add(_destination);
    });
    _getPolyline(tappedPoint.latitude, tappedPoint.longitude);

    var location = await _locationTracker.getLocation();

    _oldLatitude = location.latitude;
    _oldLongitude = location.longitude;
    oldTime = DateTime.now();
    if (active == false)
      showShortToast(
          SharedData.getGlobalLang().mustEnableTracking(), Colors.orangeAccent);
  }

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

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _getPolyline(var lat, var long) async {
    /// add origin marker origin marker
    // var   currentPosition = await _locationTracker.getLocation();
    var currentPosition = await geo.Geolocator.getCurrentPosition();
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

  Future<double> getDistance(LatLng latLng, latlng2) async {
    List<LatLng> polylineCoordinates = [];
    p.PolylinePoints polylinePoints = p.PolylinePoints();
    LatLng startLocation = latLng;
    LatLng endLocation = latlng2;
    double totalDistance = 0;

    polylinePoints
        .getRouteBetweenCoordinates(
      kGoogleApiKey,
      p.PointLatLng(startLocation.latitude, startLocation.longitude),
      p.PointLatLng(endLocation.latitude, endLocation.longitude),
    )
        .then((value) {
      if (value.points.isNotEmpty) {
        value.points.forEach((p.PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(value.errorMessage);
      }
      //polulineCoordinates is the List of longitute and latidtude.

      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += calculateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude);
      }
    });

    return totalDistance;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))) * 1000;
  }

  double rad(final double degrees) => (degrees * pi / 180.0);

  Future getCurrentPosition() async {
    currentPosition = await _locationTracker.getLocation();
  }

  // double vincentyGreatCircleDistance(
  //   double oldLatitude,
  //   double oldLongitude,
  //   double newLatitude,
  //   double newLongitude,
  // ) {
  //   // convert from degrees to radians
  //
  //   var distance =
  //       getDistance(oldLatitude, oldLongitude, newLatitude, newLongitude);
  //   print("distance before check: $distance");
  //   return distance;
  // }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      // var address = await Geocoder.local.findAddressesFromQuery(p.description);

    }
  }

  final Set<Marker> markerss = new Set();

  Future<Set<Marker>> getMarkers() async {
    List<MarkerModel> myList =
        await Provider.of<EventProvider>(context, listen: false).getEvents();
    List<MarkerModel> myList2;
    MarkerModel markerModel;
    for (int i = 0; i < myList.length; i++) {
      //   myList[i]['event_name']

      markerss.add(Marker(
        //add second marker
        markerId: MarkerId(myList[i].postede_id.toString()),
        position: LatLng(myList[i].lat, myList[i].lng), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: '${myList[i].type_name}',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    }
    setState(() {});

    return markerss;
  }

  _stopListening() {
    print("someone called me ");
    _locSubscription?.cancel();
    setState(() {
      _locSubscription = null;
    });
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
                        onPressed: () async {
                          if (active == false) {
                            if (_lng_endpoint != null) {
                              setState(() {
                                active = !active;
                              });
                              showShortToast(
                                  SharedData.getGlobalLang()
                                      .activatedSuccessfully(),
                                  Colors.green);

                              _locSubscription = _locationTracker
                                  .onLocationChanged
                                  .handleError((onError) {
                                _locSubscription?.cancel();
                                setState(() {
                                  _locSubscription = null;
                                });
                              }).listen(
                                      (loc.LocationData currentLocation) async {
                                //    setState(() {
                                _oldLatitude = currentLocation.latitude;
                                _oldLongitude = currentLocation.longitude;
                                oldTime = DateTime.now();
                                //  });

                                _sendLiveLocation(context);
                              });
                            } else {
                              showShortToast(
                                  SharedData.getGlobalLang()
                                      .selectDestination(),
                                  Colors.orangeAccent);
                            }
                          } else {
                            if (senderID != null) {
                              bool result;
                              Provider.of<EventProvider>(context, listen: false)
                                  .stopTracking(senderID, beneficiarie_id)
                                  .then((value) {
                                result = value;
                                if (result) {
                                  setState(() {
                                    active = !active;
                                  });
                                  _stopListening();
                                  resetDestination();
                                  showShortToast(
                                      SharedData.getGlobalLang()
                                          .deactivatedSuccessfully(),
                                      Colors.green);
                                } else {
                                  showShortToast(
                                      SharedData.getGlobalLang()
                                          .unableAccessSystem(),
                                      Colors.orangeAccent);
                                }
                              });
                            } else {
                              showShortToast(
                                  SharedData.getGlobalLang()
                                      .unableAccessSystem(),
                                  Colors.orangeAccent);
                            }
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
              ),
              tooltip: SharedData.getGlobalLang().enableTrackingUnit(),
            )
          ],
          leading: IconButton(
            tooltip: SharedData.getGlobalLang().back(),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(), //<-- SEE HERE
              padding: EdgeInsets.all(10),
            ),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              // if active is true then we need show alert to the user to check
              SharedClass.getBox().then((value) {
                value.put('lat_endpoint', _lat_endpoint);
                value.put('lng_endpoint', _lng_endpoint);
                value.put('destination', _destination);
                value.put('traffic', traffic);
                value.put('active', active);
              });
              Navigator.pop(context);
            },
          ),
        ),
        body: _kGooglePlex == null
            ? Container(child: Center(child: customCircularProgressIndicator()))
            : Stack(
                children: [
                  GoogleMap(
                    //zoomControlsEnabled: false,
                    trafficEnabled: traffic,
                    myLocationEnabled: true,
                    onTap: handleTap,
                    onLongPress: (val) {
                      resetDestination();
                    },
                    myLocationButtonEnabled: false,
                    mapType: maptype,
                    initialCameraPosition: _kGooglePlex,
                    polylines: Set<Polyline>.of(polylines.values),
                    // markers: Set<Marker>.of(markers.values),
                    markers: markerss,
                    //   circles: Set.of((circle != null) ? [circle] : []),
                    onMapCreated: (GoogleMapController controller) async {
                      setState(() {
                        _controller.complete(controller);
                      });
                    },
                    onCameraMoveStarted: () async {
                      if (_locationSubscription != null) {
                        _locationSubscription.cancel();
                      }
                      //   _locationSubscription.cancel();
                      Uint8List imageData = await getMarker();
                      var position = await _locationTracker.getLocation();
                      // geo.Position position =
                      //     await geo.Geolocator.getCurrentPosition(
                      //         desiredAccuracy: desiredAccuracy);
                      updateMarkerAndCircle(position, imageData);
                    },
                  ),
                  Positioned(
                      child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff33333d),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: PopupMenuButton(
                            color: Colors.deepOrange,
                            icon: Icon(FontAwesomeIcons.layerGroup),
                            itemBuilder: (builder) {
                              return customPopupMenuEntry(context);
                            },
                            onSelected: (value) {
                              switch (value) {
                                case 0:
                                  setState(() {
                                    maptype = MapType.normal;
                                  });
                                  break;
                                case 1:
                                  setState(() {
                                    maptype = MapType.hybrid;
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
                                final detail =
                                    await plist.getDetailsByPlaceId(placeid);
                                final geometry = detail.result.geometry;
                                var newlatlang = LatLng(geometry.location.lat,
                                    geometry.location.lng);
                                if (_locationSubscription != null)
                                  _locationSubscription.cancel();
                                //move map camera to selected place with animation
                                controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: newlatlang, zoom: 17)));
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff33333d),
                            elevation: 0,
                            shape: CircleBorder(), //<-- SEE HERE
                            // padding: EdgeInsets.all(10),
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
                            color:
                                traffic == true ? Colors.green : Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff33333d),
                              shape: CircleBorder(),
                              elevation: 0 //<-- SEE HERE
                              // padding: EdgeInsets.all(10),
                              ),
                        ),
                        PopupMenuButton(
                          color: Colors.deepOrange,
                          tooltip: SharedData.getGlobalLang().GPSAccuracy(),
                          icon: Icon(
                            Icons.pin_drop_rounded,
                            size: 28,
                          ),
                          itemBuilder: (builder) {
                            return customPopupMenuEntry(context,
                                low: SharedData.getGlobalLang().lowAccuracy(),
                                medium:
                                    SharedData.getGlobalLang().mediumAccuracy(),
                                high: SharedData.getGlobalLang().highAccuracy(),
                                best:
                                    SharedData.getGlobalLang().bestAccuracy());
                          },
                          onSelected: (value) {
                            switch (value) {
                              case 0:
                                setState(() {
                                  desiredAccuracy =
                                      loc.LocationAccuracy.powerSave;
                                });
                                break;
                              case 1:
                                setState(() {
                                  desiredAccuracy = loc.LocationAccuracy.low;
                                });
                                break;
                              case 2:
                                setState(() {
                                  desiredAccuracy =
                                      loc.LocationAccuracy.balanced;
                                });
                                break;
                              case 3:
                                setState(() {
                                  desiredAccuracy = loc.LocationAccuracy.high;
                                });
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  )),
                  Positioned(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.temperatureThreeQuarters,
                              color: Colors.orangeAccent,
                              size: 24,
                            ),
                            Text(
                              "${weather}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
              var position = await _locationTracker.getLocation();
              // geo.Position position = await geo.Geolocator.getCurrentPosition(
              //     desiredAccuracy: desiredAccuracy);
              updateMarkerAndCircle(position, imageData);

              if (_locationSubscription != null) {
                _locationSubscription.cancel();
              }
              // i need to review this code again ...
              final geo.LocationSettings locationSettings =
                  geo.LocationSettings(
                accuracy: geo.LocationAccuracy.high,
                distanceFilter: 0,
              );

              // _locationSubscription = geo.Geolocator.getPositionStream(
              //         locationSettings: locationSettings)
              //     .listen((geo.Position position) {
              if (controller != null) {
                _lat_startpoint = position.latitude;
                _lng_startpoint = position.longitude;
                loc.LocationData;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        //bearing: 0,
                        target: LatLng(position.latitude, position.longitude),
                        // tilt: 0,
                        zoom: 18.0)));
                updateMarkerAndCircle(position, imageData);
                //  print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
              }
              //  });
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

  void resetDestination() {
    setState(() {
      polylines.clear();
      _lng_endpoint = null;
      _lat_endpoint = null;
      markerss.remove(_destination);
      _destination = null;
    });
  }
}
