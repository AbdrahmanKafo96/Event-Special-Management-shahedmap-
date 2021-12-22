import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/HomePage/EventFolder/EventSectionOne.dart';
import 'package:systemevents/HomePage/EventFolder/MapPage.dart';
import 'package:systemevents/HomePage/HomePage.dart';
import 'package:systemevents/provider/EventProvider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'VideoPicker.dart';
import 'PickEventImage.dart';
import 'eventForm.dart';
import 'eventCategoryWidget.dart';
import 'dart:ui' as ui;

class EventSectionTow extends StatefulWidget {
  @override
  _EventSectionTowState createState() => _EventSectionTowState();
}

class _EventSectionTowState extends State<EventSectionTow> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'حدث جديد',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {

                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            actions: [

              IconButton(
                  icon: Icon(
                    Icons.check,
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await Singleton.getPrefInstace();
                    Map userData = Map();
                    userData = {
                      'description':
                          Provider.of<EventProvider>(context, listen: false)
                              .event
                              .getDescription,
                      'event_name':
                          Provider.of<EventProvider>(context, listen: false)
                              .event
                              .getEventName,
                      'sender_id': prefs.getInt('user_id').toString(),
                      'senddate': DateFormat('yyyy-MM-dd')
                          .format(DateTime.now())
                          .toString(),
                      'eventtype':
                          Provider.of<EventProvider>(context, listen: false)
                              .event
                              .eventType
                              .type_id
                              .toString(),
                      'lat': Provider.of<EventProvider>(context, listen: false)
                          .event
                          .getLat
                          .toString(),
                      'lng': Provider.of<EventProvider>(context, listen: false)
                          .event
                          .getLng
                          .toString(),
                    };

                    bool result =
                        await Provider.of<EventProvider>(context, listen: false)
                            .addEvent(userData, context);
                    if (result) {
                      showShortToast('تمت العملية بنجاح', Colors.green);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      showShortToast(
                          'حدثت مشكلة تحقق من اتصالك بالانترنت', Colors.red);
                    }
                  })
            ],
          ),
          body: Container(

            margin: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 25),
           // padding:

            width: double.infinity,

               child: Container(
                 padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                           // Text("حدد موقع الحدث" ,style: Theme.of(context).textTheme.headline6,),
                           //  InkWell(
                           //    onTap: (){
                           //      Navigator.push(
                           //        context,
                           //        MaterialPageRoute(builder: (context) => MapPage()),
                           //      );
                           //    },
                           //    child: IconShadowWidget(
                           //      Icon(
                           //        Icons.add_location_alt,
                           //        color: Colors.lightGreen,
                           //        size: 24.0,
                           //      ),
                           //      shadowColor: Colors.black,
                           //    ),
                           //  ),
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white10)),
                              label: Text("حدد موقع الحدث",style: TextStyle(color: Colors.black),),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MapPage()),
                                  );
                                },
                                icon:  Icon(
                                    Icons.add_location_alt,
                                    color: Colors.lightGreen,
                                    size: 24.0,
                                  ),),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomCategoryEvent(),

                        VideoPicker(),
                      ],
                    )
                  ]),
                )

                // Divider(),

          )),
    );
  }
}
// Consumer<EventProvider>(
// builder: (context, myInput, child){
// return ;})

// ListView(
// scrollDirection: Axis.vertical,
// shrinkWrap: true,
// children: [
// MyCustomImage(),
// EventForm(),
// SizedBox(
// height: 10,
// ),
// ExtraMedia(),
// CustomCategoryEvent(),
// Divider(),
// ],
// )