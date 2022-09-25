import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shahed/widgets/custom_indecator.dart';
class Mappoly extends StatefulWidget {
  double lat, lng;

  Mappoly({this.lat, this.lng});

  @override
  _MappolyState createState() => _MappolyState();
}

class _MappolyState extends State<Mappoly> {
  GoogleMapController mapController;

  // Markers to show points on the map
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  Position currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _kGooglePlex;

  var geoLocator = Geolocator();
  var locationOptions = LocationSettings(
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
    getCurrentPosition().then((value) {
      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14,
        );
      });
      return value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    polylines = null;
    _kGooglePlex = null;
    mapController = null;
    initialCameraPosition = null;
    _controller = null;
    markers = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          context,
        title: 'موقع الحدث' ,
        icon: FontAwesomeIcons.bomb
      ),
      body: _kGooglePlex == null
          ?customCircularProgressIndicator()
          : GoogleMap(
              padding: EdgeInsets.only(top: 135),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                _getPolyline(widget.lat, widget.lng);
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
    PolylineId id = PolylineId(
      "poly",
    );
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline(var lat, var long) async {
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
      "${Singleton.mapApiKey}",
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

