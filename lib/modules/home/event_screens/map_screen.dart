import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/widgets/customToast.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class MapPage extends StatefulWidget {
  double lat ,lng;
  MapPage({this.lat, this.lng});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapPage> {

  GoogleMapController _gcontroller;
   Location _locationService = Location();
  BitmapDescriptor customMarker; //attribute
  //List<Polyline> myPolyline = [];
  Completer<GoogleMapController> _cController = Completer();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: widget.lan!=null? LatLng(widget.lan, widget.lng): LatLng(26.3351, 17.2283),
  //   zoom: 6,
  // );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LocationData initialLocation;
  LocationData _currentLocation;
  MapType maptype;

  StreamSubscription<LocationData> _locationSubscription;
  PermissionStatus _permissionGranted;

  List<Marker> myMarker = [];


  handleTap(LatLng tappedPoint) async{

         Provider.of<EventProvider>(context, listen: false).event.setLat =
             tappedPoint.latitude;
         Provider.of<EventProvider>(context, listen: false).event.setLng =
             tappedPoint.longitude;
         print(tappedPoint.latitude);
         print(tappedPoint.longitude);
         setState(() {
           myMarker = [];
           myMarker.add(Marker(
             markerId: MarkerId(tappedPoint.toString()),
             position: tappedPoint,
           ));
           Provider.of<EventProvider>(context, listen: false).event.tappedPoint=tappedPoint;
         });

  }

  String error = "";

  @override
  void initState() {
    super.initState();
   // createPloyLine();
    maptype = MapType.normal;
   if( Provider.of<EventProvider>(context, listen: false).event.tappedPoint !=null

   ){
     LatLng result=Provider.of<EventProvider>(context, listen: false).event.tappedPoint;
     setState(() {
       myMarker = [];
       myMarker.add(Marker(
         markerId: MarkerId(result.toString()),
         position: result,
       ));

     });
   }
  }
  // createPloyLine()  {
  //   LocationData currentLocation;
  //   var location =   Location();
  //
  //         location.getLocation().then((value) {
  //
  //        setState(() {
  //          myPolyline.add(
  //            Polyline(
  //                polylineId: PolylineId('1'),
  //                color: Colors.blue,
  //                width: 3,
  //                points: [
  //                  widget.lat!=null? LatLng(widget.lat, widget.lng):
  //                  LatLng(26.3351, 17.2283),
  //                  LatLng(value.latitude, value.longitude),
  //                ],
  //                patterns: [
  //              //    PatternItem.dash(20),
  //                //  PatternItem.gap(10),
  //                ]),
  //          );
  //        });
  //       });
  //
  // }

  customAlertForButton(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            child: AlertDialog(
              content: Text("هل انت متأكد من عنوان الحدث ؟"),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "نعم",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    showShortToast('تم تحديث موقع الحدث بنجاح', Colors.green);
                    Map getResult={
                      'lat':Provider.of<EventProvider>(context, listen: false).event.getLat,
                      'lng':Provider.of<EventProvider>(context, listen: false).event.getLng
                    };
                    Navigator.of(context).pop(getResult);
                    Navigator.of(context).pop(getResult);

                  },
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return   Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton:  FloatingActionButton.extended(
        onPressed:()async{
          final GoogleMapController controller = await _cController.future;
          LocationData currentLocation;
          var location = new Location();
          try {
            currentLocation = await location.getLocation();
          } on Exception {
            currentLocation = null;
          }

          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 0,
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 15.0,
            ),
          ));
        },
        label: Text('الموقع الحالي'),
        icon: Icon(Icons.location_on),
      ),
        appBar: AppBar(
          elevation: 0,
          //backgroundColor: Colors.teal,
          title: Text(
            "حدد موقع الحدث",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading:PopupMenuButton(
            itemBuilder: (builder) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Hybrid'),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Normal'),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text('Satellite'),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text('Terrain'),
                ),
              ];
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

          actions: [
            IconButton(icon: Icon(Icons.add_location ,color: Colors.white ,),
              onPressed: (){

                if(Provider.of<EventProvider>(context, listen: false).event.getLat ==null
                    &&
                    Provider.of<EventProvider>(context, listen: false).event.getLng==null
                ){
                  showShortToast('يجب تحديد موقع الحدث', Colors.orange);
                }else{
                  customAlertForButton(context);
                }
              },),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Stack(
            children: [

              GoogleMap(
             //  polylines: myPolyline.toSet(),
                layoutDirection: TextDirection.rtl,
                onLongPress: (val){
                 setState(() {
                   myMarker.removeAt(0);
                   Provider.of<EventProvider>(context, listen: false).event.tappedPoint=null;
                   Provider.of<EventProvider>(context, listen: false).event.setLat=null;
                   Provider.of<EventProvider>(context, listen: false).event.setLng=null;
                 });
                },
                myLocationButtonEnabled: false,
                mapType: maptype,
                onTap: handleTap,
                initialCameraPosition:
                    CameraPosition(target:widget.lat!=null? LatLng(widget.lat, widget.lng):
                    LatLng(26.3351, 17.2283) , zoom: widget.lat!=null?15:5),
                onMapCreated: (GoogleMapController controller) {
                  _cController.complete(controller );
                },
                myLocationEnabled: true,
                markers: Set<Marker>.of(myMarker),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  hoverColor: Colors.grey,
                  highlightColor: Colors.grey,
                  icon: Icon(Icons.arrow_back ,color: Colors.black87,),
                  onPressed: (){
                    Provider.of<EventProvider>(context, listen: false).event.setLat =
                    null;
                    Provider.of<EventProvider>(context, listen: false).event.setLng =
                   null;

                    Provider.of<EventProvider>(context, listen: false).event.tappedPoint=null;
                    Navigator.of(context).pop();
                  },),),
            ],
          ),
        ),
      ),
    );
  }

  // initPlatformState() async {
  //   await _locationService.changeSettings(
  //       accuracy: LocationAccuracy.high, interval: 1000);
  //
  //   LocationData locationData;
  //   try {
  //     bool serviceEnabled = await _locationService.serviceEnabled();
  //     if (serviceEnabled) {
  //       PermissionStatus p;
  //
  //       _permissionGranted = (await _locationService.requestPermission());
  //       if (_permissionGranted.index == 0) {
  //         locationData = await _locationService.getLocation();
  //         enableLocationSubscription();
  //       }
  //     } else {
  //       bool serviceRequestGranted = await _locationService.requestService();
  //       if (serviceRequestGranted) {
  //         initPlatformState();
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //     if (e.code == 'PERMISSION_DENIED') {
  //       error = e.message;
  //     } else if (e.code == 'SERVICE_STATUS_ERROR') {
  //       error = e.message;
  //     }
  //     //locationData = null;
  //   }
  //
  //   setState(() {
  //     initialLocation = locationData;
  //   });
  // }

  // enableLocationSubscription() async {
  //   _locationSubscription =
  //       _locationService.onLocationChanged.listen((LocationData result) async {
  //     if (mounted) {
  //       setState(() {
  //         _currentLocation = result;
  //
  //         markers.clear();
  //         MarkerId markerId1 = MarkerId("Current");
  //         Marker marker1 = Marker(
  //           markerId: markerId1,
  //           position: LatLng(26.3351, 17.2283),
  //           icon:
  //               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //         );
  //         markers[markerId1] = marker1;
  //         animateCamera(marker1);
  //       });
  //     }
  //   });
  // }
  //
  // slowRefresh() async {
  //   if (_locationSubscription != null) _locationSubscription.cancel();
  //   await _locationService.changeSettings(
  //       accuracy: LocationAccuracy.balanced, interval: 10000);
  //   enableLocationSubscription();
  // }
  //
  // animateCamera(marker1) async {
  //   final GoogleMapController controller = await _cController.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(marker1));
  // }
}
