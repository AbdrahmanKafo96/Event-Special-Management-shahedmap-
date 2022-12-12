// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// class Important extends StatefulWidget {
//   List path;
//   Important({this.path});
//   @override
//   State<Important> createState() => _ImportantState();
// }
//
// class _ImportantState extends State<Important> {
//   Map<PolylineId, Polyline> polylines = {};
//   int _polylineIdCounter = 1;
//   Completer<GoogleMapController> _controller = Completer();
//   void _addPath() {
//
//     final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
//
//     final PolylineId polylineId = PolylineId(polylineIdVal);
//
//     final Polyline polyline = Polyline(
//       polylineId: polylineId,
//       consumeTapEvents: true,
//       color: Colors.red,
//       width: 5,
//       points: _createPoints(),
//     );
//
//     setState(() {
//       polylines[polylineId] = polyline;
//     });
//   }
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.path);
//    // print(widget.path.map((e) => LatLng(e['lat'],e['lng']) ).toList());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink,
//         title: Text("Maps"),
//         actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: _addPath)],
//       ),
//       body: GoogleMap(
//           compassEnabled: true,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//           buildingsEnabled: false,
//           onMapCreated: (GoogleMapController controller) async {
//             setState(() {
//               _controller.complete(controller);
//             });
//           },
//         initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 4.0),
//         polylines: Set<Polyline>.of(polylines.values),
//       ),
//     );
//   }
//   List<LatLng> _createPoints() {
//     return widget.path.map((e) => LatLng(e['lat'],e['long']) ).toList();
//   }
// }
