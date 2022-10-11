import 'package:flutter/material.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/custom_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shahed/main.dart';
import 'package:location/location.dart' as loc;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Telephony telephony = Telephony.instance;
 // String _message = "";

  @override
  void initState() {
    super.initState();
    if (SharedData.getUserState()) {
      LocationPermission permission;

      Geolocator.checkPermission().then((value) {
        Geolocator.requestPermission().then((value) {
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then((value) {
            Workmanager().initialize(
              callbackDispatcher,
              isInDebugMode: false,
            );
            Workmanager().registerPeriodicTask(
              "1",
              "fetchBackground",
              frequency: Duration(minutes: 15),
            );
          });
        });
      });
    }
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
          dashboardItem(context, SharedData.getGlobalLang().eventList(), FontAwesomeIcons.list,
              'eventList', Colors.blue),
          // if (SharedData.getUserState())
          //   dashboardItem(context, SharedData.getGlobalLang().trackingUnit(), Icons.track_changes,
          //       'unitTracking', Colors.teal),

          if (SharedData.getUserState())
            dashboardItem(context, SharedData.getGlobalLang().notifications(), FontAwesomeIcons.bell,
                'response', Colors.redAccent),
          if (SharedData.getUserState())
          dashboardItem(context, SharedData.getGlobalLang().missionsList(), FontAwesomeIcons.route,
              'Missions', Colors.orange),
          dashboardItem(context, SharedData.getGlobalLang().notifyAgency(), FontAwesomeIcons.users,
              'Inform', Colors.greenAccent),
          // dashboardItem(
          //       context, "الإشعارات", FontAwesomeIcons.bell, 'serc',Colors.redAccent),
        ],
      ),
    );
  }

  viewPage(BuildContext ctx, String view) {
    return Navigator.of(ctx).pushNamed(
      view,
      arguments: (route) => false,
    );
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
      child: customCard(icon, title, color, ctx),
    );
  }

//
}
