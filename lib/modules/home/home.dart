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
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:systemevents/notification/notification.dart' as notif;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Position  position;

  bool state = false;
  int selected;
  String countryName = "";
  String subAdminArea = "";
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List<MyList> mylist = [];

  @override
  void initState() {
    super.initState();
    addObj();
    _getUserLocation();
    Singleton.getPrefInstance().then((value) {
      if (value.getInt('role_id') == 4) {
        setState(() {
          state = true;
        });
      }
    });
  }

  viewPage(BuildContext ctx, String view) {
    return Navigator.of(ctx).pushNamed(
      view,
      arguments: (route) => false,
    );
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
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xFF00695C),
                Color(0xFF4DB6AC),
              ],
            )),
          ),
          actions: [
            state == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.locationArrow),
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
          ],
          centerTitle: true,
          elevation: 0,
          titleSpacing: 1.0,
          title: Text(
            "الصفحة الرئيسية",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
        drawer: Drawer(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.9),
            child: Stack(children: [
              
              Positioned(
                bottom: -120,
                right: 0,
                child: Container(
                  child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 7,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF00695C),
                            Color(0xFF4DB6AC),
                          ],
                        )),
                    width: 500,
                    height: 200,
                  ),
                ),
              ),
              Positioned(
                top: -120,
                left: 0,
                child: Container(
                  decoration: const BoxDecoration(

                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00695C),
                          Color(0xFF4DB6AC),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                  ),
                  width: 500,
                  height: 200,
                ),
              ),
              Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: UserAccountsDrawerHeader(
                          margin: EdgeInsets.zero,
                          arrowColor: Colors.redAccent,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.0),
                          ),
                          accountName: Text("Abdulrahman kafu"),
                          accountEmail: Text("bedootk90@gmail.com"),
                          currentAccountPicture: CircleAvatar(
                            //backgroundColor: Colors.orange,
                            child: Text(
                              "A",
                              style: TextStyle(fontSize: 40.0),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
// Important: Remove any padding from the ListView.
                        shrinkWrap: true,
                        itemCount: mylist.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  //  side: BorderSide(color: Colors.white70, width: 1),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                focusColor: Colors.redAccent,

                                title: Text('${mylist[index].title}'),
                                leading: Icon(mylist[index].icon),
                               // tileColor: selected == index ? Colors.blue : Colors.teal.withOpacity(0.4),
                                onTap: () {
                                  setState(() {
                                    selected = index;
                                  });
                                  if (mylist[index].routPage == "logout")
                                    Provider.of<UserAuthProvider>(context,
                                        listen: false)
                                        .logout(context);
                                  else {
                                    viewPage(mylist[index].context,
                                        mylist[index].routPage);
                                  }
                                },
                              ),
                              //    SizedBox(height: 8,),
                              if(index!=mylist.length-1)
                              Divider()
                            ],
                          );
                        },
                      )
                    ],
                  ))
            ])));
  }

  void addObj() {
    mylist.add(MyList(
        title: 'الاعدادت',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.cog,
        routPage: "settings"));

    mylist.add(MyList(
        title: 'الصفحة الشخصية',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.solidUser,
        routPage: "ProfilePage"));

    mylist.add(MyList(
        title: 'تعيين كلمة المرور',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.key,
        routPage: "ResetPage"));

    mylist.add(MyList(
        title: 'حول التطبيق',
        color: Colors.grey,
        context: context,
        icon: FontAwesomeIcons.addressCard,
        routPage: "About"));

    mylist.add(MyList(
        title: 'تسجيل الخروج',
        color: Colors.grey,
        //  context: context,
        icon: FontAwesomeIcons.signOut,
        routPage: "logout"));
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
    // print(' countryName=${first.countryName},adminArea= ${first.adminArea},subLocality=${first.subLocality}, '
    //     '${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, '
    //     'subThoroughfare=${first.subThoroughfare}');
    return first;
  }
}
