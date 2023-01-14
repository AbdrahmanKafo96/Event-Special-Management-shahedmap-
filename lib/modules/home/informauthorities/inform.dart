import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/authentications/logo.dart';
import 'package:shahed/modules/home/event_screens/event_category.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/customDirectionality.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:telephony/telephony.dart';
import 'package:location/location.dart' as loc;

class InformEntity extends StatelessWidget {
  final Telephony telephony = Telephony.instance;
  loc.Location location = loc.Location();
  loc.LocationData ?userLocation;

  @override
  Widget build(BuildContext context) {
    return  customDirectionality(
      child: Scaffold(
          appBar: customAppBar(context,title:  SharedData.getGlobalLang().notifyAgency(), actions: [
            IconButton(
              icon: Icon(Icons.how_to_vote),
              onPressed: () async {
                String? type_name =
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .eventType
                        .type_name;

                String ?category_name =
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .categoryClass
                        .category_name;
                int ?emergency_phone =
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .categoryClass
                        .emergency_phone;
                userLocation = await location.getLocation();

                double longitude = userLocation!.longitude!;
                double latitude = userLocation!.latitude!;
                // final SmsSendStatusListener listener = (SendStatus status) {};
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
                  await Flushbar(
                    //  title: 'Hey Ninja',
                    message: SharedData.getGlobalLang().categoryTypeAreRequired(),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 3),
                  ).show(context);
                } else {
                  await telephony.sendSmsByDefaultApp(
                    to: "+218${emergency_phone.toString()}",
                    message: message,
                    // statusListener: listener,
                  );
                  showShortToast(SharedData.getGlobalLang().checkMessagesApp(), Colors.green);
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

                  Navigator.pop(context);
                }
              },
              tooltip: SharedData.getGlobalLang().sendReport(),
            )
          ]),
          body: Container(
             color: Color(0xff424250),
              padding: EdgeInsets.all(10),
              height: double.maxFinite,
              child: Column(
                children: [
                  Logo('sendreport.png' ,height: 100,),
                  Text(
                    SharedData.getGlobalLang().ContactGovernmentAgencies(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    SharedData.getGlobalLang().chooseCategoryType(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                   EventCategory(),
                ],
              )),
      ),
    );
  }
}
