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

  double lat , lng;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  Color myColor=Colors.white;
  String errorMessage1,errorMessage2 ,errorMessage3,errorMessage4;
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
                              // تحتاج تعديل
                      if(!(errorMessage1=="" && errorMessage2=="" && errorMessage3 =="" && errorMessage4=="")){
                        if (Provider.of<EventProvider>(context, listen: false).event.getLat==null ) {
                          errorMessage1='يجب ان تختار موقع الحدث';
                          setState(() {
                            myColor=Colors.red;
                          });
                        }else{
                          setState(() {
                            errorMessage1="";
                          });
                        }  if(Provider.of<EventProvider>
                          (context, listen: false).event.categoryClass.category_id==null||
                            Provider.of<EventProvider>
                              (context, listen: false).event.categoryClass.category_name=='اختار الصنف'){
                          errorMessage2='يجب ان تختار الصنف';
                          setState(() {
                            myColor=Colors.red;
                          });
                        }else{
                          setState(() {
                            errorMessage2="";
                          });
                        }  if(Provider.of<EventProvider>(context, listen: false)
                            .event.eventType.type_name==null || Provider.of<EventProvider>(context, listen: false)
                            .event.eventType.type_name=='اختار النوع'){
                          errorMessage3='يجب ان تختار النوع';
                          setState(() {
                            myColor=Colors.red;
                          });

                        }else{
                          setState(() {
                            errorMessage3="";
                          });
                        }
                        if(Provider.of<EventProvider>(context, listen: false).event.getXFile==null||
                            Provider.of<EventProvider>(context, listen: false).event.getXFile.isEmpty){
                          errorMessage4='يجب ان ترفق صورة للحدث' ;
                          setState(() {
                            myColor=Colors.red;
                          });
                        }else{
                          setState(() {
                            errorMessage4="";
                          });
                        }
                      }
                      else{
                        setState(() {
                          myColor=Colors.white;
                        });
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
                      border: Border.all(
                        color: myColor,
                        width: 2,
                      ),
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
                                  Text(lng==null?'حدد موقع الحدث':"عدل موقع الحدث", style: Theme.of(context).textTheme.headline6,),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                hoverColor: Colors.blueGrey,
                                onTap: () async {
                               Map fetchResult=  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MapPage()),
                                  );
                               setState(() {
                                 print(fetchResult['lat']);
                                 lat=fetchResult['lat'];
                                 lng=fetchResult['lng'];
                               });
                                },
                                child:Container(

                                  child: ListTile(
                                          title: Text(lng==null?
                                          "موقع الحدث":"موقع الحدث الحالي" ,  style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14),),

                                          subtitle: Text(lng==null?
                                          'يمكنك اختيار موقع الحدث من هنا':"${lat},${lng}",
                                          style: TextStyle(fontSize: 12),
                                          ),
                                          trailing: Container(
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                  bottomLeft: Radius.circular(12),
                                                  bottomRight: Radius.circular(12)
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  spreadRadius: 4,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Container(

                                              width: 50,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(lng==null?Icons.location_on:Icons.edit_location_outlined)
                                                ],
                                              ),
                                            ),
                                          ),
                                          isThreeLine: true,
                                          tileColor: Colors.white,
                                        ),
                                 // margin: EdgeInsets.only(left: 50, top: 80, right: 50, bottom: 80),

                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12)
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey.withOpacity(0.2),
                                        spreadRadius: 4,
                                        blurRadius: 3,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),

                               ),

                              Text(errorMessage1!=null?errorMessage1:"" ,style: TextStyle(fontSize: 14 , color: Colors.red),),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                Text(
                                  "اختيار الصنف والنوع",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],),
                              EventCategory(),

                              Text(errorMessage2!=null &&errorMessage3!=null?
                              "${errorMessage2} ${errorMessage3}":"" ,
                                style: TextStyle(fontSize: 14 , color: Colors.red),),
                              Row(children: [
                                Text(
                                  "إضافة صور",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],),
                              PickImages(),

                              Text(errorMessage4==null?"":errorMessage4 ,style: TextStyle(fontSize: 14 , color: Colors.red),) ,
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
//