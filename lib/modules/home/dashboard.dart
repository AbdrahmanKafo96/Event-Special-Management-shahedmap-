import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/customCard.dart';
import 'package:systemevents/web_browser/webView.dart';
import 'package:systemevents/widgets/customToast.dart';
import 'package:systemevents/widgets/dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:workmanager/workmanager.dart';
import 'package:systemevents/main.dart';
import 'package:location/location.dart' as loc;

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool state = false;
  final Telephony telephony = Telephony.instance;
  String _message = "";

  @override
  void initState() {
    super.initState();
    Singleton.getPrefInstance().then((value) async {
      if (value.getInt('role_id') == 4) {
        setState(() {
          state = true;
        });
        LocationPermission permission;

        Geolocator.checkPermission().then((value) {
          Geolocator.requestPermission().then((value) {
            Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high)
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            dashboardItem(context, "قائمة الاحداث", Icons.list, 'eventList'),
            dashboardItem(
                context, "تصفح الموقع", Icons.language, 'CustomWebView'),
            dashboardItem(
                context, "تواصل مع الجهات", Icons.people, 'CustomWebView'),
            if (state == true)
              dashboardItem(
                  context, "قائمة الاستجابات", Icons.list, 'response'),
          ],
        ),
      ),
    );
  }

  viewPage(BuildContext ctx, String view) {
    return Navigator.of(ctx).pushNamed(
      view,
      arguments: (route) => false,
    );
  }

  Widget dashboardItem(
      BuildContext ctx, String title, IconData icon, String routName) {
    // var mode=Singleton.getPrefInstance().then((value) {
    //
    // });
    return InkWell(
      onTap: () async {
        loc.Location location = loc.Location();
        bool _serviceEnabled;
        loc.PermissionStatus _permissionGranted;
        loc.LocationData userLocation;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();

        if (_permissionGranted == loc.PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();}
          if (_permissionGranted == loc.PermissionStatus.granted) {
            if (title == "تواصل مع الجهات") {
              createDialog(ctx, "اختيار الصنف والنوع", 'إرسال', (
                  {TextEditingController textEditingController}) async {
                String type_name =
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .eventType
                        .type_name;

                String category_name =
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .categoryClass
                        .category_name;
                int emergency_phone =
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .categoryClass
                        .emergency_phone;
                userLocation = await location.getLocation();


                double longitude = userLocation.longitude;
                double latitude = userLocation.latitude;
                final SmsSendStatusListener listener = (SendStatus status) {

                };
                String message = "تطبيق الحدث" +
                    "\n" +
                    "https://www.google.com/maps/@$latitude,$longitude,15z" +
                    "\n" +
                    "النوع=$category_name" +
                    "\n" +
                    "التصنيف=$type_name";
                print(message);
                if (latitude == null ||
                    longitude == null ||
                    category_name == null ||
                    type_name == null) {
                  //         ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  //           key: _scaffoldkey,
                  //   content: Text(
                  //     'يجب ان تدخل الصنف والنوع',
                  //     textDirection: TextDirection.rtl,
                  //   ),
                  //   backgroundColor: Colors.orangeAccent,
                  // ));
                  await Flushbar(
                    //  title: 'Hey Ninja',
                    message: 'يجب ان تدخل الصنف والنوع',
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 3),
                  ).show(context);
                } else {

                 await telephony.sendSmsByDefaultApp(
                      to: "+218${emergency_phone.toString()}",
                      message: message,
                     // statusListener: listener,
                       );
                  showShortToast('تحقق من تطبيق الرسائل', Colors.green);
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .eventType
                      .type_name = null;

                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .categoryClass
                      .category_name = null;
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .categoryClass
                      .emergency_phone = null;
                  double longitude = null;
                  double latitude = null;
                  Navigator.pop(context);
                }
              }, num: 1);
            } else {
              viewPage(ctx, routName);
            }
          }

      },
      child: customCard(icon, title),
    );
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
      if (_message == 'delivered') showShortToast('تم الاستلام', Colors.green);
    });
  }

  Future<void> initPlatformState() async {
    final bool result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
      );
    }

    if (!mounted) return;
  }

}
