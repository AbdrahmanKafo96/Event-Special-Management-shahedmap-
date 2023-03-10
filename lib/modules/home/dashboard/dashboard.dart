import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/event.dart';
import 'package:shahed/modules/home/event_screens/main_section.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/custom_card.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart' as tel;
//import 'package:workmanager/workmanager.dart';
import 'package:shahed/main.dart';
import 'package:location/location.dart' as loc;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../provider/event_provider.dart';
import '../../../theme/colors_app.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final tel.Telephony telephony = tel.Telephony.instance;

  // String _message = "";

  @override
  void initState() {
    super.initState();

    // if (SharedData.getUserState()) {
    //   Geolocator.checkPermission().then((value) {
    //     Geolocator.requestPermission().then((value) {
    //       Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //           .then((value) {
    //         Workmanager().initialize(
    //           callbackDispatcher,
    //           isInDebugMode: false,
    //         );
    //         Workmanager().registerPeriodicTask("1", "fetchBackground",
    //             frequency: Duration(minutes: 15),
    //             constraints: Constraints(
    //               networkType: NetworkType.connected,
    //               requiresBatteryNotLow: false,
    //             ));
    //
    //       });
    //     });
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(1.0),
        children: <Widget>[
          dashboardItem(context, SharedData.getGlobalLang().addEvent(),
              FontAwesomeIcons.locationDot, 'addEvent', SharedColor.deepOrange),
          //  if (SharedData.getUserState())
          if (   SharedData.getUserState()  )
          dashboardItem(context, SharedData.getGlobalLang().browseMap(),
              FontAwesomeIcons.mapLocationDot, 'browserMap', SharedColor.teal),

          if (SharedData.getUserState() )
            dashboardItem(context, SharedData.getGlobalLang().notifications(),
                FontAwesomeIcons.bell, 'response', SharedColor.redAccent),
          if (SharedData.getUserState() )
            dashboardItem(context, SharedData.getGlobalLang().missionsList(),
                FontAwesomeIcons.solidComment, 'Missions', SharedColor.orange),

          dashboardItem(context, SharedData.getGlobalLang().notifyAgency(),
              FontAwesomeIcons.users, 'Inform', SharedColor.greenAccent),

          dashboardItem(context, SharedData.getGlobalLang().eventList(),
              FontAwesomeIcons.list, 'eventList', SharedColor.blue),
        ],
      ),
    );
  }

  viewPage(BuildContext ctx, String viewName) {
    if (viewName == 'addEvent') {
      checkInternetConnectivity(ctx).then((bool value) async {
        if (value) {
          Provider.of<EventProvider>(ctx, listen: false).event = Event();
          Navigator.push(
            context,
            //MaterialPageRoute(builder: (context) => EventSectionOne()),
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => EventSectionOne(),
              transitionDuration: Duration.zero,
            ),
          );
        }
      });
    } else {
      print("from the dashboard$viewName");
      Navigator.pushNamed(context, viewName);
      // return Navigator.of(ctx).pushNamed(
      //   viewName,
      //   // arguments: (route) => false,
      // );
    }
  }

  Widget dashboardItem(BuildContext ctx, String title, IconData icon,
      String routName, Color color) {
    // var mode=Singleton.getPrefInstance().then((value) {
    //
    // });
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () async {
        loc.Location location = loc.Location();
        bool _serviceEnabled;
        loc.PermissionStatus _permissionGranted;
        //loc.LocationData userLocation;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();

        if (_permissionGranted == loc.PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
        }
        if (_permissionGranted == loc.PermissionStatus.granted) {
          viewPage(ctx, routName);
        }
      },
      child: customCard(icon, title, color, ctx , routName),
    );
  }

//
}
