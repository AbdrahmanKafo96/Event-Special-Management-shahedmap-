import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/customDirectionality.dart';
import 'package:shahed/widgets/customPopupMenuEntry.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_dialog.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:weather/weather.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart' as p;

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
  String weather = "";

  handleTap(LatLng tappedPoint) async {

    Provider.of<EventProvider>(context, listen: false).event.setLat =
        tappedPoint.latitude;
    Provider.of<EventProvider>(context, listen: false).event.setLng =
        tappedPoint.longitude;
    WeatherFactory wf = Singleton.getWeatherFactory();
    Weather w = await wf.currentWeatherByLocation(
        tappedPoint.latitude, tappedPoint.longitude);
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: tappedPoint.latitude,
        longitude: tappedPoint.longitude,
        googleMapApiKey: "${Singleton.mapApiKey}");
    setState(() {
      weather = w.temperature.celsius.toInt().toString();
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        infoWindow: InfoWindow(
          title: "${data.address}",
          snippet: "${data.state}",
        ),
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
    return   customDirectionality(
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final GoogleMapController controller = await _cController.future;
              LocationData currentLocation;
              var location = Location();
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
              SharedData.getGlobalLang().currentLocation(),
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
            title: SharedData.getGlobalLang().locateEvent(),
            leading: PopupMenuButton(
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
                    showShortToast(SharedData.getGlobalLang().locationRequired(), Colors.orange);
                  } else {
                    customReusableShowDialog(
                      context,
                     SharedData.getGlobalLang().locateEvent(),
                      widget: Text(SharedData.getGlobalLang().alertLocationEvent()),
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
                              SharedData.getGlobalLang().okay(),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            onPressed: () {
                              showShortToast(
                                 SharedData.getGlobalLang().positionSuccessfully() , Colors.green);
                              Map getResult = {
                                'lat': Provider.of<EventProvider>(context,
                                        listen: false)
                                    .event
                                    .getLat,
                                'lng': Provider.of<EventProvider>(context,
                                        listen: false)
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
                    child: Column(
                      children: [
                        IconButton(
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
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           children: [
                             Icon(
                               FontAwesomeIcons.temperatureThreeQuarters,
                               color: Colors.black87,
                               size: 24,
                             ),
                             SizedBox(
                               width: 12,
                             ),
                             Text(
                               "${weather}",
                               style: TextStyle(
                                   color: Colors.black87,
                                   fontSize: 24,
                                   fontWeight: FontWeight.bold),
                               // overflow: TextOverflow.ellipsis,
                             ),
                           ],
                         ),
                       ),
                        ElevatedButton(
                          onPressed: () async {
                            final GoogleMapController controller =
                                await _cController.future;
                            String location = "Search Location";
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: Singleton.mapApiKey,
                                mode: Mode.overlay,
                                hint: 'بحث',
                                types: [],
                                strictbounds: false,
                                components: [
                                  p.Component(p.Component.country, 'ly'),
                                  p.Component(p.Component.country, 'gb'),
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
                              final plist = p.GoogleMapsPlaces(
                                apiKey: Singleton.mapApiKey,
                                apiHeaders: await GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );
                              String placeid = place.placeId ?? "0";
                              final detail =
                                  await plist.getDetailsByPlaceId(placeid);
                              final geometry = detail.result.geometry;
                              final lat = geometry.location.lat;
                              final lang = geometry.location.lng;
                              var newlatlang = LatLng(lat, lang);

                              //move map camera to selected place with animation
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: newlatlang, zoom: 17)));
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.grey,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), //<-- SEE HERE
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
      ),
    );
  }
}
