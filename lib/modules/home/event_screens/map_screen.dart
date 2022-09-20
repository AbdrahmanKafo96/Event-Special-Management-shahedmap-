import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/widgets/custom_app_bar.dart';
import 'package:systemevents/widgets/custom_dialog.dart';
import 'package:systemevents/widgets/custom_toast.dart';
import 'package:systemevents/provider/event_provider.dart';


class MapMarker extends StatefulWidget {
  double lat, lng;

  MapMarker({this.lat, this.lng});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapMarker> {
  BitmapDescriptor customMarker; //attribute
  Completer<GoogleMapController> _cController = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  LocationData initialLocation;
  MapType maptype;

  List<Marker> myMarker = [];

  handleTap(LatLng tappedPoint) async {
    Provider.of<EventProvider>(context, listen: false).event.setLat =
        tappedPoint.latitude;
    Provider.of<EventProvider>(context, listen: false).event.setLng =
        tappedPoint.longitude;

    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      Provider.of<EventProvider>(context, listen: false).event.tappedPoint =
          tappedPoint;
    });
  }


  @override
  void initState() {
    super.initState();
    // createPloyLine();
    maptype = MapType.normal;
    if (Provider.of<EventProvider>(context, listen: false).event.tappedPoint !=
        null) {
      LatLng result =
          Provider.of<EventProvider>(context, listen: false).event.tappedPoint;
      setState(() {
        myMarker = [];
        myMarker.add(Marker(
          markerId: MarkerId(result.toString()),
          position: result,
        ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
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
              target:
                  LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 15.0,
            ),
          ));
        },
        hoverColor: Color(0xFFFF8F00),
        backgroundColor: Color(0xFFfe6e00),
        label: Text(
          'الموقع الحالي',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        icon: Icon(
          Icons.location_on,
          color: Colors.white,
        ),
      ),
      appBar: customAppBar(
        context,
        //backgroundColor: Colors.teal,
        title: "حدد موقع الحدث",
        leading: PopupMenuButton(
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
          IconButton(
            icon: Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            onPressed: () {
              if (Provider.of<EventProvider>(context, listen: false)
                          .event
                          .getLat ==
                      null &&
                  Provider.of<EventProvider>(context, listen: false)
                          .event
                          .getLng ==
                      null) {
                showShortToast('يجب تحديد موقع الحدث', Colors.orange);
              } else {
                customReusableShowDialog(
                  context,
                  'تحديد موقع الحدث',
                  widget: Text("هل انت متأكد من عنوان الحدث ؟"),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "إلغاء",
                        style:TextStyle(color: Colors.grey),
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
                          "نعم",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: () {
                          showShortToast('تم تحديث موقع الحدث بنجاح', Colors.green);
                          Map getResult = {
                            'lat': Provider.of<EventProvider>(context, listen: false)
                                .event
                                .getLat,
                            'lng': Provider.of<EventProvider>(context, listen: false)
                                .event
                                .getLng
                          };
                          Navigator.of(context).pop(getResult);
                          Navigator.of(context).pop(getResult);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          children: [
            GoogleMap(
              //  polylines: myPolyline.toSet(),
              layoutDirection: TextDirection.rtl,
              onLongPress: (val) {
                setState(() {
                  myMarker.removeAt(0);
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .tappedPoint = null;
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .setLat = null;
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .setLng = null;
                });
              },
              myLocationButtonEnabled: false,
              mapType: maptype,
              onTap: handleTap,
              initialCameraPosition: CameraPosition(
                  target: widget.lat != null
                      ? LatLng(widget.lat, widget.lng)
                      : LatLng(26.3351, 17.2283),
                  zoom: widget.lat != null ? 15 : 5),
              onMapCreated: (GoogleMapController controller) {
                _cController.complete(controller);
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
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .setLat = null;
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .setLng = null;

                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .tappedPoint = null;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
