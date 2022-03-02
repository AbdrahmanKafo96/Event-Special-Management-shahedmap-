import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapMap extends StatefulWidget {
  double lat ,lng;
  MapMap({this.lat, this.lng});

  @override
  _MapMapState createState() => _MapMapState();
}

class _MapMapState extends State<MapMap> {
  GoogleMapController mapController;

  // Markers to show points on the map
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  Position currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex ;


  var geoLocator = Geolocator();
  var locationOptions =  LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
    );
   Future getCurrentPosition() async {

        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);

  }
  CameraPosition initialCameraPosition;
  @override
  void initState() {
    super.initState();
    getCurrentPosition().then((value){



      setState(() {
      _kGooglePlex=CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 14 ,
      );

      });
      return value;

    });

  }
@override
  void dispose() {
    super.dispose();
    polylines=null;
    _kGooglePlex=null;
    mapController=null;
    initialCameraPosition=null;
    _controller=null;
    markers=null;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(centerTitle: true,title: Text('الاستجابة'),),
        body:_kGooglePlex==null?Container(child: Center(child: CircularProgressIndicator(color: Colors.green,)))  : GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            _getPolyline(widget.lat,widget.lng);
          },
          polylines: Set<Polyline>.of(polylines.values),
          markers: Set<Marker>.of(markers.values),
        ),

    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline(var lat , var long) async {
    /// add origin marker origin marker
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

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyD_zQR-4DgIbGEQrgv4ENebE430KtB0fOk",
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(lat, long),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}

// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' ;
// import "package:location/location.dart";
// import "package:flutter/material.dart";
// import "dart:async";
//
//
// const double CAMERA_ZOOM = 16;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
//  const LatLng SOURCE_LOCATION = LatLng(32.844604,13.042492);
//  const LatLng DEST_LOCATION = LatLng(26.3351,17.2283);
// class MapMap extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => MapMapState();
// }
//   class MapMapState extends State<MapMap> {
//
//     Completer<GoogleMapController> _controller = Completer();
//     Set<Marker> _markers = Set<Marker>();
// // for my drawn routes on the map
//     Set<Polyline> _polylines = Set<Polyline>();
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints;
//     String googleAPIKey = "AIzaSyD_zQR-4DgIbGEQrgv4ENebE430KtB0fOk";
// // for my custom marker pins
//     BitmapDescriptor sourceIcon;
//     BitmapDescriptor destinationIcon;
// // the user's initial location and current location
// // as it moves
//     LocationData currentLocation;
// // a reference to the destination location
//     LocationData destinationLocation;
// // wrapper around the location API
//     Location location;
//     @override
//     void initState() {
//       super.initState();
//
//       // create an instance of Location
//       location = new Location();
//       polylinePoints = PolylinePoints();
//
//       // subscribe to changes in the user's location
//       // by "listening" to the location's onLocationChanged event
//       location.onLocationChanged .listen((LocationData cLoc) {
//         // cLoc contains the lat and long of the
//         // current user's position in real time,
//         // so we're holding on to it
//         currentLocation = cLoc;
//         updatePinOnMap();
//       });
//       // set custom marker pins
//       setSourceAndDestinationIcons();
//       // set the initial location
//       setInitialLocation();
//     }
//     void setSourceAndDestinationIcons() async {
//       sourceIcon = await BitmapDescriptor.fromAssetImage(
//           ImageConfiguration(devicePixelRatio: 2.5),
//           'assets/driving_pin.png');
//
//       destinationIcon = await BitmapDescriptor.fromAssetImage(
//           ImageConfiguration(devicePixelRatio: 2.5),
//           'assets/destination_map_marker.png');
//     }
//     void setInitialLocation() async {
//       // set the initial location by pulling the user's
//       // current location from the location's getLocation()
//       currentLocation = await location.getLocation();
//
//       // hard-coded destination for this example
//       destinationLocation = LocationData.fromMap({
//         "latitude": DEST_LOCATION.latitude,
//         "longitude": DEST_LOCATION.longitude
//       });
//     }
//     @override
//     Widget build(BuildContext context) {
//       CameraPosition initialCameraPosition = CameraPosition(
//           zoom: CAMERA_ZOOM,
//           tilt: CAMERA_TILT,
//           bearing: CAMERA_BEARING,
//           target: SOURCE_LOCATION
//       );
//       if (currentLocation != null) {
//         initialCameraPosition = CameraPosition(
//             target: LatLng(currentLocation.latitude,
//                 currentLocation.longitude),
//             zoom: CAMERA_ZOOM,
//             tilt: CAMERA_TILT,
//             bearing: CAMERA_BEARING
//         );
//       }
//       return Scaffold(
//         body: Stack(
//           children: <Widget>[
//             GoogleMap(
//                 myLocationEnabled: true,
//                 compassEnabled: true,
//                 tiltGesturesEnabled: false,
//                 markers: _markers,
//                 polylines: _polylines,
//                 mapType: MapType.normal,
//                 initialCameraPosition: initialCameraPosition,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                   // my map has completed being created;
//                   // i'm ready to show the pins on the map
//                   showPinsOnMap();
//                 })
//           ],
//         ),
//       );
//     }
//     void showPinsOnMap() {
//       // get a LatLng for the source location
//       // from the LocationData currentLocation object
//       var pinPosition = LatLng(currentLocation.latitude,
//           currentLocation.longitude);
//       // get a LatLng out of the LocationData object
//       var destPosition = LatLng(destinationLocation.latitude,
//           destinationLocation.longitude);
//       // add the initial source location pin
//       _markers.add(Marker(
//           markerId: MarkerId('sourcePin'),
//           position: pinPosition,
//           icon: sourceIcon
//       ));
//       // destination pin
//       _markers.add(Marker(
//           markerId: MarkerId('destPin'),
//           position: destPosition,
//           icon: destinationIcon
//       ));
//       // set the route lines on the map from source to destination
//       // for more info follow this tutorial
//       setPolylines();
//     }
//     void setPolylines() async {
//       setState(() async{
//       PolylineResult  result = await polylinePoints.getRouteBetweenCoordinates(
//           googleAPIKey,
//           PointLatLng( SOURCE_LOCATION.latitude,
//             SOURCE_LOCATION.longitude,),
//           PointLatLng(DEST_LOCATION.latitude,
//               DEST_LOCATION.longitude),travelMode: TravelMode.driving,);
//
//       if(result.points.isNotEmpty){
//         result.points.forEach((PointLatLng point){
//           polylineCoordinates.add(
//               LatLng(point.latitude,point.longitude)
//           );
//         });
//
//           _polylines.add(Polyline(
//               width: 5, // set the width of the polylines
//               polylineId: PolylineId('poly'),
//               color: Color.fromARGB(255, 40, 122, 198),
//               points: polylineCoordinates
//           ));
//
//       } });
//     }
//     void updatePinOnMap() async {
//
//       // create a new CameraPosition instance
//       // every time the location changes, so the camera
//       // follows the pin as it moves with an animation
//       CameraPosition cPosition = CameraPosition(
//         zoom: CAMERA_ZOOM,
//         tilt: CAMERA_TILT,
//         bearing: CAMERA_BEARING,
//         target: LatLng(currentLocation.latitude,
//             currentLocation.longitude),
//       );
//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
//       // do this inside the setState() so Flutter gets notified
//       // that a widget update is due
//       setState(() {
//         // updated position
//         var pinPosition = LatLng(currentLocation.latitude,
//             currentLocation.longitude);
//
//         // the trick is to remove the marker (by id)
//         // and add it again at the updated location
//         _markers.removeWhere(
//                 (m) => m.markerId.value == 'sourcePin');
//         _markers.add(Marker(
//             markerId: MarkerId('sourcePin'),
//             position: pinPosition, // updated position
//             icon: sourceIcon
//         ));
//       });
//     }}




  //   GoogleMapController mapController;
  //   // double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  //   // double _destLatitude = 6.849660, _destLongitude = 3.648190;
  //   double _originLatitude = 26.48424, _originLongitude = 50.04551;
  //   double _destLatitude = 26.46423, _destLongitude = 50.06358;
  //   Map<MarkerId, Marker> markers = {};
  //   Map<PolylineId, Polyline> polylines = {};
  //   List<LatLng> polylineCoordinates = [];
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   String googleAPiKey = "AIzaSyD_zQR-4DgIbGEQrgv4ENebE430KtB0fOk";
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //
  //     /// origin marker
  //     _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
  //         BitmapDescriptor.defaultMarker);
  //
  //     /// destination marker
  //     _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
  //         BitmapDescriptor.defaultMarkerWithHue(90));
  //     _getPolyline();
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return SafeArea(
  //       child: Scaffold(
  //           body: GoogleMap(
  //             initialCameraPosition: CameraPosition(
  //                 target: LatLng(_originLatitude, _originLongitude), zoom: 15),
  //             myLocationEnabled: true,
  //             tiltGesturesEnabled: true,
  //             compassEnabled: true,
  //             scrollGesturesEnabled: true,
  //             zoomGesturesEnabled: true,
  //             onMapCreated: _onMapCreated,
  //             markers: Set<Marker>.of(markers.values),
  //             polylines: Set<Polyline>.of(polylines.values),
  //           )),
  //     );
  //   }
  //
  //   void _onMapCreated(GoogleMapController controller) async {
  //     mapController = controller;
  //   }
  //
  //   _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
  //     MarkerId markerId = MarkerId(id);
  //     Marker marker =
  //     Marker(markerId: markerId, icon: descriptor, position: position ,);
  //     markers[markerId] = marker;
  //   }
  //
  //   _addPolyLine() {
  //
  //     setState(() {
  //       PolylineId id = PolylineId("poly");
  //       Polyline polyline = Polyline(
  //           patterns: [PatternItem.dash(10), PatternItem.gap(10)],
  //           // startCap: Cap.roundCap,
  //           // endCap: Cap.roundCap,
  //           polylineId: id, color: Colors.red, points: polylineCoordinates);
  //       polylines[id] = polyline;
  //     });
  //   }
  //
  //   _getPolyline() async {
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //         googleAPiKey,
  //         PointLatLng(_originLatitude, _originLongitude),
  //         PointLatLng(_destLatitude, _destLongitude),
  //         travelMode: TravelMode.driving,
  //         wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
  //     if (result.points.isNotEmpty) {
  //       result.points.forEach((PointLatLng point) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       });
  //     }
  //     _addPolyLine();
  //   }
  // }
