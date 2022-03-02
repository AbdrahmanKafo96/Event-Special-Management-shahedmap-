import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/modules/home/event_screens/event_images.dart';
import 'package:systemevents/modules/home/event_screens/extra_section.dart';
import 'package:systemevents/modules/home/event_screens/map_screen.dart';
import 'package:systemevents/widgets/customToast.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'event_category.dart';
import 'dart:ui' as ui;

class EventSectionOne extends StatefulWidget {
  @override
  _EventSectionOneState createState() => _EventSectionOneState();
}

class _EventSectionOneState extends State<EventSectionOne> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'حدث جديد',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                tooltip: 'إلغاء الحدث',
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Provider.of<EventProvider>(context, listen: false).event.dropAll();
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              actions: [

               IconButton(
                   onPressed: () {
                     print(Provider.of<EventProvider>(context, listen: false)
                         .event.eventType.type_name);
                      if (Provider.of<EventProvider>(context, listen: false).event.getLat==null ) {
                          showShortToast('يجب ان تختار الموقع', Colors.orange);
                     }else if(Provider.of<EventProvider>
                        (context, listen: false).event.categoryClass.category_id==null){
                        showShortToast('يجب ان تختار الصنف', Colors.orange);
                      }else if(Provider.of<EventProvider>(context, listen: false)
                          .event.eventType.type_name==null){
                        showShortToast('يجب ان تختار النوع', Colors.orange);
                      }
                      else if(Provider.of<EventProvider>(context, listen: false).event.getXFile==null){
                       showShortToast('يجب ان ترفق صورة الحدث', Colors.orange);
                     }
                      else{
                       Navigator
                           .of(context).pushReplacement( MaterialPageRoute(builder:
                           (BuildContext context) => EventSectionTow() ));
                     }
                   },
                   tooltip: 'التالي',
                   icon: Icon(
                     Icons.check,
                   ))
              ],
            ),
            body: Container(
                margin: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 25),
                // padding:
                width: double.infinity,

                child: Container(

                  width: MediaQuery.of(context).size.width,
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
                        Container(
                          // margin: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('حدد موقع الحدث', style: Theme.of(context).textTheme.headline6,),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MapPage()),
                                  );
                                },
                                child: Stack(children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10,  right: 10,),
                                    height: 120.0,
                                    // width:MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                         // spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/mapScreenshot.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.rectangle,
                                    ),
                                  ),
                                 Positioned.fill(

                                     child: Align(
                                         alignment: Alignment.center,
                                         child: Icon(Icons.add_location ,color: Colors.green,)))
                                ],)
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(children: [
                                Text(
                                  "اختيار الصنف والنوع",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],),
                              EventCategory(),

                              Row(children: [
                                Text(
                                  "إضافة صور",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],),
                              PickImages(),
                            ],
                          ),
                        )
                      ]),
                )

              // Divider(),

            )),
      ),
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