import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/event_screens/event_images.dart';
import 'package:shahed/modules/home/event_screens/extra_section.dart';
import 'package:shahed/modules/home/event_screens/map_screen.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/customDirectionality.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/widgets/custom_indecator.dart';
import '../../../theme/colors_app.dart';
import 'event_category.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventSectionOne extends StatefulWidget {
  @override
  _EventSectionOneState createState() => _EventSectionOneState();
}

class _EventSectionOneState extends State<EventSectionOne> {
  double? lat, lng;
  bool load = true;

  List<Marker>? myMarker = [];
  GoogleMapController? mapController ;

  callme() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callme();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color myColor = SharedColor.black;
  String? errorMessage1, errorMessage2, errorMessage3, errorMessage4;
  CameraPosition camera =
      CameraPosition(target: LatLng(26.3351, 17.2283), zoom: 4);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: customDirectionality(
        child: Scaffold(
            appBar: customAppBar(
              context,
              title: SharedData.getGlobalLang().newEvent(),
              leading: IconButton(
                tooltip: SharedData.getGlobalLang().cancel(),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .dropAll();
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (lat == null) {
                        errorMessage1 =
                            SharedData.getGlobalLang().locationRequired();
                        setState(() {
                          myColor = SharedColor.red;
                        });
                      } else {
                        setState(() {
                          errorMessage1 = "";
                        });
                      }
                      if (Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .categoryClass
                                  .category_id ==
                              null ||
                          Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .categoryClass
                                  .category_name ==
                              SharedData.getGlobalLang().chooseCategory() ||
                          Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .categoryClass
                                  .category_id ==
                              0) {
                        Provider.of<EventProvider>(context, listen: false)
                            .event
                            .eventType
                            .type_id = null;
                        Provider.of<EventProvider>(context, listen: false)
                                .event
                                .eventType
                                .type_name =
                            SharedData.getGlobalLang().chooseType();

                        errorMessage2 =
                            SharedData.getGlobalLang().categoryRequired();
                        setState(() {
                          myColor = SharedColor.red;
                        });
                      } else {
                        setState(() {
                          errorMessage2 = "";
                        });
                      }

                      if (Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .eventType
                                  .type_id ==
                              null ||
                          Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .eventType
                                  .type_name ==
                              SharedData.getGlobalLang().chooseType() ||
                          Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .eventType
                                  .type_name ==
                              "") {
                        errorMessage3 =
                            SharedData.getGlobalLang().typeRequired();
                        setState(() {
                          myColor = SharedColor.red;
                        });
                      } else {
                        setState(() {
                          errorMessage3 = "";
                        });
                      }
                      if (Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .getXFile
                                  .length ==
                              null ||
                          Provider.of<EventProvider>(context, listen: false)
                              .event
                              .getXFile
                              .isEmpty ||
                          Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .getXFile
                                  .length ==
                              0) {
                        errorMessage4 =
                            SharedData.getGlobalLang().imageRequired();
                        setState(() {
                          myColor = SharedColor.red;
                        });
                      } else {
                        setState(() {
                          errorMessage4 = "";
                        });
                      }

                      if (errorMessage1 == "" &&
                          errorMessage2 == "" &&
                          errorMessage3 == "" &&
                          errorMessage4 == "") {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                EventSectionTow()));
                      }
                    },
                    tooltip: SharedData.getGlobalLang().next(),
                    icon: Icon(
                      Icons.check,
                    ))
              ],
            ),
            body: load == true
                ? Center(child: customCircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.only(
                        left: 10, top: 15, right: 10, bottom: 10),
                    // padding:
                    width: double.infinity,
                    //  width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(SharedColor.darkIntColor),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: SharedColor.black12.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              Text(
                                lng == null
                                    ? SharedData.getGlobalLang().pickLocation()
                                    : SharedData.getGlobalLang()
                                        .modifyLocation(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),

                          Container(
                            height: 200,
                            margin: EdgeInsets.only(
                                left: 5, top: 5, right: 5, bottom: 5),
                            width: double.maxFinite,
                            child: GoogleMap(
                              onTap: (val) async {
                                Location location = await Location();
                                bool _serviceEnabled;
                                PermissionStatus _permissionGranted;
                                _serviceEnabled =
                                    await location.serviceEnabled();
                                if (!_serviceEnabled) {
                                  _serviceEnabled =
                                      await location.requestService();
                                  if (!_serviceEnabled) {}
                                }

                                _permissionGranted =
                                    await location.hasPermission();
                                if (_permissionGranted ==
                                    PermissionStatus.denied) {
                                  _permissionGranted =
                                      await location.requestPermission();
                                }
                                if (_permissionGranted ==
                                    PermissionStatus.granted) {
                                  Map fetchResult = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapMarker()),
                                  );
                                  setState(() {
                                    lat = fetchResult['lat'];
                                    lng = fetchResult['lng'];
                                    var tappedPoint = LatLng(lat!, lng!);

                                    myMarker!.add(Marker(
                                      markerId: MarkerId("asd"),
                                      position: tappedPoint,
                                    ));
                                    mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: tappedPoint, zoom: 17)
                                            //17 is new zoom level
                                            ));
                                  });
                                }
                              },
                              markers: Set<Marker>.of(myMarker!),
                              initialCameraPosition: camera,
                              onMapCreated: (controller) {
                                //method called when map is created
                                setState(() {
                                  mapController = controller;
                                });
                              },
                            ),
                          ),
                          Text(
                            errorMessage1 != null ? errorMessage1! : "",
                            style: TextStyle(fontSize: 14, color: SharedColor.red),
                          ),

                          Row(
                            children: [
                              Text(
                                SharedData.getGlobalLang().chooseCategoryType(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          EventCategory(),
                          Text(
                            errorMessage2 != null && errorMessage3 != null
                                ? "${errorMessage2} ${errorMessage3}"
                                : "",
                            style: TextStyle(fontSize: 14, color: SharedColor.red),
                          ),
                          Row(
                            children: [
                              Text(
                                SharedData.getGlobalLang().addImages(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          //PickImages(),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: Card(
                              shadowColor: Color(SharedColor.greyIntColor),
                              elevation: 0.5,
                              color: Color(SharedColor.greyIntColor),
                              shape: RoundedRectangleBorder(
                                //  side: BorderSide(color: SharedColor.gr, width: 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                  topLeft: Radius.circular(24),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      SharedData.getGlobalLang().pickImages(),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 5, left: 5),
                                      child: Text(
                                        SharedData.getGlobalLang()
                                            .imageMessage(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                    PickImages(),
                                    Text(
                                      errorMessage4 == null
                                          ? ""
                                          : errorMessage4!,
                                      style: TextStyle(
                                          fontSize: 14, color: SharedColor.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Text(
                          //   errorMessage4 == null ? "" : errorMessage4,
                          //   style:
                          //       TextStyle(fontSize: 14, color: SharedColor.red),
                          // ),
                        ]),
                  )),
      ),
    );
  }
}
//
