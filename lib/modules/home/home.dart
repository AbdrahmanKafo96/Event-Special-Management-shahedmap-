import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/models/category.dart';
import 'package:systemevents/models/event.dart';
import 'package:systemevents/modules/home/dashboard.dart';
import 'package:systemevents/modules/home/event_screens/main_section.dart';
import 'package:systemevents/modules/home/tracking/unit_tracking.dart';
import 'package:systemevents/provider/auth_provider.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/shared_data/shareddata.dart';
import 'package:systemevents/widgets/custom_app_bar.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:systemevents/notification/notification.dart' as notif;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:systemevents/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Position  position;
  String countryName = "";
  String subAdminArea = "";
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  GlobalKey _appbarkey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _getUserLocation();

  }



  @override
  Widget build(BuildContext context) {
    //   checkInternetConnectivity(context);
    return Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: false,
        // floatingActionButtonLocation: FloatingActionButtonLocation,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            checkInternetConnectivity(context).then((bool value) async {
              if (value) {
                Provider.of<EventProvider>(context, listen: false).event =
                    Event();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventSectionOne()),
                );
              }
            });
          },
          tooltip: 'اضف حدث',
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
          backgroundColor: Colors.green,
        ),
          appBar:  customAppBar(title: " الصفحة الرئيسية " , icon: FontAwesomeIcons.home, actions:[
              SharedData.getUserState() == true
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(  Icons.track_changes),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UnitTracking()),
                );
              },
            ),
          )
              : SizedBox.shrink(),
      ], ),

        body: ListView(
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                //  side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              //  color:Color(0xFF5a8f62),
              elevation: 2.0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00695C),
                        Color(0xFF4DB6AC),
                      ],
                    )),
                padding: EdgeInsets.only(right: 10, bottom: 10, left: 10),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "مرحبا أحمد!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            FontAwesomeIcons.globe,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "$countryName",
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            FontAwesomeIcons.locationCrosshairs,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              subAdminArea,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Dashboard(),
          ],
        ),
        drawer:CustomDrawer()
    );
  }



  _getUserLocation() async {
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    //currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      countryName = first.countryName;
      subAdminArea = first.addressLine;
    });

    return first;
  }
}
