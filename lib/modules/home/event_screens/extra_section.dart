import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/modules/home/event_screens/SuccessPage.dart';
import 'package:systemevents/modules/home/event_screens/event_screen.dart';
import 'package:systemevents/modules/home/home.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:systemevents/widgets/custom_toast.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';

class EventSectionTow extends StatefulWidget {
  @override
  _EventSectionTowState createState() => _EventSectionTowState();
}

class _EventSectionTowState extends State<EventSectionTow> {

  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),


        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00695C) ,
                        Color(0xFF4DB6AC),
                      ],
                    )),
              ),
              title: Text(
                'بيانات الحدث',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                tooltip: 'اغلاق',
                icon: Icon(Icons.clear),
                onPressed: () {
                  Provider.of<EventProvider>(context, listen: false)
                      .event
                      .dropAll();
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              actions: [

              ],
            ),
            body: Container(

              margin  : EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 25),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     spreadRadius: 5,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 3), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: EventForm() ),


                   SizedBox(height: 6,),
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 24),

                    shape: StadiumBorder(),
                  ),
                  child: isLoading?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    CircularProgressIndicator(color: Colors.white,),
                    const SizedBox(height: 18,),
                      const SizedBox(width: 10,),
                    Text("انتظر من فضلك...")

                  ],):Text('إرسال الحدث'),
                    onPressed: ()  async {
                    if(isLoading)return;

                    setState(()=>isLoading=true);
                      await Future.delayed(Duration(seconds: 3));
                    checkInternetConnectivity(context)
                        .then((bool value) async {
                      if (value) {

                        if(Provider.of<EventProvider>(context,
                            listen: false)
                            .event
                            .getDescription!="" && Provider.of<EventProvider>(context,
                            listen: false)
                            .event
                            .getDescription!=null  ){
                          Box box =
                          await Singleton.getBox();
                          Map userData = Map();
                          userData = {
                            'description': Provider.of<EventProvider>(context,
                                listen: false)
                                .event
                                .getDescription,
                            'event_name': Provider.of<EventProvider>(context,
                                listen: false)
                                .event
                                .eventType
                                .type_name
                                .toString(),
                            'sender_id': box.get('user_id').toString(),
                            'senddate': DateFormat('yyyy-MM-dd')
                                .format(DateTime.now())
                                .toString(),
                            'eventtype': Provider.of<EventProvider>(context,
                                listen: false)
                                .event
                                .eventType
                                .type_id
                                .toString(),
                            'lat': Provider.of<EventProvider>(context,
                                listen: false)
                                .event
                                .getLat
                                .toString(),
                            'lng': Provider.of<EventProvider>(context,
                                listen: false)
                                .event
                                .getLng
                                .toString(),
                          };

                          bool result = await Provider.of<EventProvider>
                            (context, listen: false).addEvent(userData);

                          if (result) {


                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SuccessPage()),
                                    (Route<dynamic> route) => false,
                              );


                          } else {

                          }
                        }else{
                          showShortToast(
                              'من فضلك ادخل وصف الحدث', Colors.red);
                        }
                      }
                    });
                    setState(()=>isLoading=false);
                    },
                  ),

                ],
              ),
            ),
          ),
        ),

    );
  }
}
