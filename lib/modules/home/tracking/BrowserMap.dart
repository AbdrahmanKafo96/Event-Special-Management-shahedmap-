import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as p;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/markermodel.dart';
import 'package:shahed/provider/counter_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/customPopupMenuEntry.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_dialog.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:weather/weather.dart';
import '../../../theme/colors_app.dart';
import '../../../widgets/custom_indecator.dart';
import 'package:location/location.dart' as loc;
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

class BrowserMap extends StatefulWidget {
  LatLng? latLngDestination;
  int? state;
  List? path;
  String? pathshasData = '';

  BrowserMap(
      {this.latLngDestination, this.state, this.path, this.pathshasData});

  @override
  State<BrowserMap> createState() => _BrowserMapState();
}

class _BrowserMapState extends State<BrowserMap> with WidgetsBindingObserver {
  StreamSubscription? _locationSubscription;

  // static StreamSubscription<loc.LocationData> _locSubscription;
  final kGoogleApiKey = SharedClass.mapApiKey;
  loc.LocationAccuracy desiredAccuracy = loc.LocationAccuracy.high;

  //GoogleMapsPlaces _places;
  Marker? marker, _destination;
  MapType? maptype = MapType.normal;
  loc.LocationData? currentPosition;
  Circle? circle;
  Completer<GoogleMapController> _controller = Completer();
  double? _lat_startpoint, _lng_startpoint, _lat_endpoint, _lng_endpoint;
  bool traffic = false;
  String weather = "";
  loc.Location _locationTracker = loc.Location();
  p.PolylinePoints polylinePoints = p.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  static CameraPosition? _kGooglePlex;
  final Set<Marker> markerss = new Set();
  int _polylineIdCounter = 1;

  // get marker like car
  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/icons/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      loc.LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    if (mounted) {
      setState(() {
        marker = Marker(
            markerId: MarkerId("home"),
            position: latlng,
            rotation: newLocalData!.heading!,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData));
        markerss.add(marker!);
        circle = Circle(
            circleId: CircleId("car"),
            radius: newLocalData.accuracy!,
            zIndex: 1,
            strokeColor: SharedColor.blueAccent,
            center: latlng,
            fillColor: SharedColor.blue.withAlpha(70));
      });
    }
    if (_lng_endpoint != null) _getPolyline(_lat_endpoint, _lng_endpoint);
  }

  Future<void> getIniLocation(loc.LocationData locationData) async {
    try {
      final GoogleMapController controller = await _controller.future;
      Uint8List imageData = await getMarker();
      var position = locationData;
      // geo.Position position = await geo.Geolocator.getCurrentPosition(
      //     desiredAccuracy: desiredAccuracy);

      updateMarkerAndCircle(position, imageData);
      if (_lng_endpoint != null) _getPolyline(_lat_endpoint, _lng_endpoint);
      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
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

    getDailyEvents();
    Wakelock.enable();

    // _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

    SharedClass.getBox().then((getValue) {
      loc.Location().getLocation().then((currentPos) {
        _kGooglePlex = CameraPosition(
          target: LatLng(currentPos.latitude!, currentPos.longitude!),
          zoom: 18,
        );
        setState(() {
          currentPosition = currentPos;
          if (widget.state == 1) {
            _lat_endpoint = widget.latLngDestination!.latitude;
            _lng_endpoint = widget.latLngDestination!.longitude;
          } else {
            _lat_endpoint = getValue.containsKey("lat_endpoint")
                ? getValue.get('lat_endpoint')
                : null;
            _lng_endpoint = getValue.containsKey("lng_endpoint")
                ? getValue.get('lng_endpoint')
                : null;
          }
          traffic =
              getValue.containsKey("traffic") ? getValue.get('traffic') : false;

          if (_lat_endpoint != null && _lng_endpoint != null) {
            _destination = Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              markerId: MarkerId(12.toString()),
              position: LatLng(_lat_endpoint!, _lng_endpoint!),
              infoWindow: InfoWindow(
                title: "last position",
                //  snippet: "${data.state}",
              ),
            );
            markerss.add(_destination!);
          }

          getIniLocation(currentPos);
        });
        //    return currentPos;
      });
    });

    if (widget.pathshasData == 'yes' && widget.state == 1) {
      _addPath();
    }
  }

  savaDataLocally() {
    SharedClass.getBox().then((value) {
      if (widget.state == 0) {
        value.put('lat_endpoint', _lat_endpoint);
        value.put('lng_endpoint', _lng_endpoint);
      }
      value.put('traffic', traffic);
      // value.put('myactive', active);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _kGooglePlex = null;
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    Wakelock.disable();
    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused ||
  //       state == AppLifecycleState.inactive)
  //     _locationTracker.enableBackgroundMode(enable: true);
  //   if (state == AppLifecycleState.resumed) {
  //     _locationTracker.enableBackgroundMode(enable: false);
  //   }
  // }

  handleTap(LatLng tappedPoint) async {
    if (widget.state == 0) {
      WeatherFactory wf = SharedClass.getWeatherFactory();
      Weather w = await wf
          .currentWeatherByLocation(tappedPoint.latitude, tappedPoint.longitude)
          .catchError((error) {
        print(error);
      });
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: tappedPoint.latitude,
          longitude: tappedPoint.longitude,
          googleMapApiKey: SharedClass.mapApiKey.toString());
      setState(() {
        resetDestination();

        _destination = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          markerId: MarkerId(521.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(
            title: "${data.address}",
            snippet: "${data.state}",
          ),
        );
        markerss.add(_destination!);
        weather = w.temperature!.celsius!.toInt().toString();
        _lat_endpoint = tappedPoint.latitude;
        _lng_endpoint = tappedPoint.longitude;
      });

      //var currentPosition = await geo.Geolocator.getCurrentPosition();
      _getPolyline(tappedPoint.latitude, tappedPoint.longitude);

      // var location = await _locationTracker.getLocation();

      savaDataLocally();
    }
  }

  void resetDestination() {
    if (widget.state == 0) {
      setState(() {
        polylines.clear();
        _lng_endpoint = null;
        _lat_endpoint = null;
        markerss.remove(_destination);
        _destination = null;
      });
    }
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId(
      "poly",
    );
    Polyline polyline = Polyline(
      polylineId: id,
      color: SharedColor.blue,
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
    //var currentPosition = await loc.Location().getLocation();
    var currentPosition = await  _locationTracker.getLocation();
    _addMarker(
      LatLng(currentPosition.latitude!, currentPosition.longitude!),
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

    p.PolylineResult result = await polylinePoints
        .getRouteBetweenCoordinates(
      "${SharedClass.mapApiKey}",
      p.PointLatLng(currentPosition.latitude!, currentPosition.longitude!),
      p.PointLatLng(lat, long),
      travelMode: p.TravelMode.walking,
    )
        .catchError((error) {
      print('error : ${error.toString()}');
    });
    if (result.points.isNotEmpty) {
      result.points.forEach((p.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
// this stm needs more review
    if (mounted) {
      _addPolyLine(polylineCoordinates);
      setState(() {});
    }
  }

  Future<Uint8List> loadNetworkImage(path) async {
    final completed = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completed.complete(info)));
    final imageInfo = await completed.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // get daily events from the server
  Future<Set<Marker>> getDailyEvents() async {
    List<MarkerModel?>? myList =
        await Provider.of<EventProvider>(context, listen: false).getEvents();

    for (int i = 0; i < myList!.length; i++) {
      Uint8List image = await loadNetworkImage(
          "${SharedClass.routePath}/storage//images/events_icons/${myList[i]!.icon}");
      final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
          image.buffer.asUint8List(),
          targetHeight: 100,
          targetWidth: 100);
      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData =
          await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();
      markerss.add(Marker(
        //add second marker
        markerId: MarkerId(myList[i]!.postede_id.toString()),
        position: LatLng(myList[i]!.lat!, myList[i]!.lng!), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: '${myList[i]!.type_name}',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.fromBytes(resizedImageMarker), //Icon for Marker
      ));
    }
    setState(() {});

    return markerss;
  }

  void _addPath() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: SharedColor.red,
      width: 5,
      points: _createPoints(),
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  List<LatLng> _createPoints() {
    return widget.path!.map((e) => LatLng(e['lat'], e['long'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: widget.state == 1
              ? SharedData.getGlobalLang().trackingUnit()
              : SharedData.getGlobalLang().browseMap(),
          icon: widget.state == 1
              ? FontAwesomeIcons.route
              : FontAwesomeIcons.mapLocationDot,
          leading: IconButton(
            tooltip: SharedData.getGlobalLang().back(),
            icon: Icon(
              Icons.arrow_back,
              color: SharedColor.white,
            ),
            onPressed: () {
              // if active is true then we need show alert to the user to check
              SharedClass.getBox().then((value) {
                if (widget.state == 0) {
                  value.put('lat_endpoint', _lat_endpoint);
                  value.put('lng_endpoint', _lng_endpoint);
                }
                //value.put('destination', _destination);
                value.put('traffic', traffic);

                Navigator.pop(context);
              });
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
                    compassEnabled: true,
                    onTap: handleTap,
                    onLongPress: (val) {
                      resetDestination();
                    },
                    myLocationButtonEnabled: false,
                    mapType: maptype!,
                    initialCameraPosition: _kGooglePlex!,
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
                        _locationSubscription!.cancel();
                      }
                      //   _locationSubscription.cancel();
                      Uint8List imageData = await getMarker();
                      //   var position = await _locationTracker.getLocation();
                      //    geo.Position position =
                      //        await geo.Geolocator.getCurrentPosition(
                      //           );
                      updateMarkerAndCircle(
                          await loc.Location().getLocation(), imageData);
                    },
                  ),
                  Positioned(
                      child: Container(
                    decoration: BoxDecoration(
                      color: Color(SharedColor.darkIntColor),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PopupMenuButton(
                          color: SharedColor.deepOrange,
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
                                  decoration:
                                      InputDecoration(fillColor: SharedColor.white),
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
                                var newlatlang = LatLng(geometry!.location.lat,
                                    geometry!.location.lng);
                                if (_locationSubscription != null)
                                  _locationSubscription!.cancel();
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
                            color: SharedColor.white,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(SharedColor.darkIntColor),
                              shape: CircleBorder(),
                              elevation: 0 //<-- SEE HERE
                              // padding: EdgeInsets.all(10),
                              ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              traffic = !traffic;
                            });
                            savaDataLocally();
                          },
                          child: Icon(
                            FontAwesomeIcons.bus,
                            color:
                                traffic == true ? SharedColor.green : SharedColor.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color(SharedColor.darkIntColor),
                            shape: CircleBorder(), //<-- SEE HERE
                            // padding: EdgeInsets.all(10),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            loc.Location location = loc.Location();
                            loc.LocationData userLocation =
                                await location.getLocation();

                            double longitude = userLocation.longitude!;
                            double latitude = userLocation.latitude!;
                            // final SmsSendStatusListener listener = (SendStatus status) {};

                            if (latitude == null || longitude == null) {
                              await Flushbar(
                                //  title: 'Hey Ninja',
                                message: SharedData.getGlobalLang()
                                    .categoryTypeAreRequired(),
                                backgroundColor: SharedColor.orange,
                                duration: Duration(seconds: 3),
                              ).show(context);
                            } else {
                              SharedClass.getBox().then((box) async {
                                Map userData = {
                                  'description': 'Urgent event.',
                                  'event_name': 'SOS',
                                  'sender_id': box.get('user_id').toString(),
                                  'senddate': DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())
                                      .toString(),
                                  'eventtype': '118',
                                  'lat': latitude.toString(),
                                  'lng': longitude.toString(),
                                };
                                var result = await Provider.of<EventProvider>(
                                        context,
                                        listen: false)
                                    .addEvent(userData);

                                if (result!)
                                  showShortToast(
                                      SharedData.getGlobalLang()
                                          .sentEvenSuccessfully(),
                                      SharedColor.green);
                                else
                                  showShortToast(
                                      SharedData.getGlobalLang()
                                          .saveWasNotSuccessful(),
                                      SharedColor.redAccent);
                              });
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.locationDot,
                            color: SharedColor.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color(SharedColor.darkIntColor),
                            shape: CircleBorder(), //<-- SEE HERE
                            // padding: EdgeInsets.all(10),
                          ),
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
                              color: SharedColor.orangeAccent,
                              size: 24,
                            ),
                            Text(
                              "${weather}",
                              style: TextStyle(
                                  color: SharedColor.black54,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.pathshasData == 'yes' && widget.path!.length > 0
                      ? Positioned(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final GoogleMapController controller =
                                          await _controller.future;
                                      if (_locationSubscription != null) {
                                        _locationSubscription!.cancel();
                                      }
                                      List<LatLng> point = _createPoints();
                                      if (controller != null) {
                                        controller.animateCamera(CameraUpdate
                                            .newCameraPosition(CameraPosition(
                                                //bearing: 0,
                                                target: LatLng(
                                                    point
                                                        .elementAt(
                                                            (point.length / 2)
                                                                .toInt())
                                                        .latitude,
                                                    point
                                                        .elementAt(
                                                            (point.length / 2)
                                                                .toInt())
                                                        .longitude),
                                                // tilt: 0,
                                                zoom: 18.0)));
                                      }
                                    },
                                    child: Icon(
                                      Icons.center_focus_strong,
                                      color: SharedColor.red,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Color(SharedColor.darkIntColor),
                                      shape: CircleBorder(), //<-- SEE HERE
                                      // padding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.location_searching,
              color: SharedColor.black12.withOpacity(.5),
            ),
            tooltip: SharedData.getGlobalLang().currentLocation(),
            backgroundColor: SharedColor.deepOrange,
            onPressed: () async {
              try {
                final GoogleMapController controller = await _controller.future;
                Uint8List imageData = await getMarker();
                var location = await _locationTracker.getLocation();

                updateMarkerAndCircle(location, imageData);

                if (_locationSubscription != null) {
                  _locationSubscription!.cancel();
                }

                _locationSubscription =
                    _locationTracker.onLocationChanged.listen((newLocalData) {
                  if (controller != null) {
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                        new CameraPosition(
                            bearing: 192.8334901395799,
                            target: LatLng(
                                newLocalData.latitude!, newLocalData.longitude!),
                            tilt: 0,
                            zoom: 18.00)));
                    updateMarkerAndCircle(newLocalData, imageData);
                  }
                });
              } on PlatformException catch (e) {
                if (e.code == 'PERMISSION_DENIED') {
                  debugPrint("Permission Denied");
                }
              }
            }),
      ),
    );
  }
}
