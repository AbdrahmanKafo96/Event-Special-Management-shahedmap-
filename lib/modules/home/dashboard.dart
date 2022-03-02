import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/customCard.dart';
import 'package:systemevents/web_browser/webView.dart';
import 'package:systemevents/widgets/dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';
class Dashboard extends StatefulWidget {

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool state=false;
  final Telephony telephony = Telephony.instance;
  String _message = "";
  @override
  void initState() {

    super.initState();
    Singleton.getPrefInstance().then((value){
      if(value.getInt('role_id')==4){
       setState(() {
         state=true;
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
            dashboardItem(context,"قائمة الاحداث", Icons.list,'eventList' ),
            dashboardItem(context,"تصفح الموقع", Icons.language,'CustomWebView'),
            dashboardItem(context,"تواصل مع الجهات", Icons.people,'CustomWebView'),
            if(state==true)dashboardItem(context,"قائمة الاستجابات", Icons.list,'response'),
          ],
        ),
      ),
    );
  }

  viewPage(   BuildContext ctx ,String view){
    return Navigator.of(ctx).pushNamed( view ,arguments: (route) => false,);
  }

  Widget  dashboardItem( BuildContext ctx,String title, IconData icon ,String routName) {
    return InkWell(
      onTap: () {
        if(title=="تواصل مع الجهات"){
          createDialog(ctx , "اختيار الصنف والنوع",'إرسال',
                ({TextEditingController textEditingController}) async {




                 String type_name=Provider.of<EventProvider>(context, listen: false)
                      .event
                      .eventType
                      .type_name ;

                  String category_name=Provider.of<EventProvider>(context, listen: false)
                      .event
                      .categoryClass
                      .category_name ;
                 int emergency_number=Provider.of<EventProvider>(context, listen: false)
                      .event
                      .categoryClass
                      .emergency_number ;

                  var userLocation = await  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


                   double longitude=  userLocation.longitude ;
                    double latitude= userLocation.latitude ;
                    final SmsSendStatusListener listener = (SendStatus status) {
                      print(status.name);
                    };
                    String message ="تطبيق الحدث"+"\n"+
                        "https://www.google.com/maps/@$latitude,$longitude,15z"+"\n"+
                        "النوع=$category_name"+"\n"+
                        "التصنيف=$type_name";

                      if(latitude==null || longitude==null || category_name==null || type_name==null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'يجب ان تدخل الصنف والنوع',
                          textDirection: TextDirection.rtl,
                        ),
                        backgroundColor: Colors.orangeAccent,
                      ));
                     } else{
                      print(emergency_number.toString());
                    telephony.sendSms(
                        to: "+218${emergency_number.toString()}",
                        message:  message,
                        statusListener: listener,
                      isMultipart: true
                    );}
                } ,num: 1);
        }else{
          viewPage(ctx ,routName);
        }
      },
      child:customCard(icon , title),
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
    });
  }
  Future<void> initPlatformState() async {


    final bool  result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage,  );
    }

    if (!mounted) return;
  }
  // void bottomSheet(BuildContext context){
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context, builder:(context){
  //     return Container(
  //       color: Color(0xFF737373),
  //       height: MediaQuery.of(context).size.height-100,
  //       child: Container(
  //         height: MediaQuery.of(context).size.height-100,
  //         // height: MediaQuery.of(context).size.height-100,
  //
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).canvasColor,
  //             borderRadius: BorderRadius.only(
  //               topLeft: const Radius.circular(30),
  //               topRight: const Radius.circular(30),
  //             )
  //         ),
  //         child:  Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               children: [
  //                 Directionality(
  //                   textDirection: TextDirection.rtl,
  //                   child: Container(
  //                     padding:  const EdgeInsets.all(5.0),
  //                     margin:const EdgeInsets.all(5.0),
  //                     //color: Colors.green,
  //                     child: Row(
  //                       children: [
  //                         IconButton(
  //
  //                           icon:Text("خروج",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14 , color: Colors.blue),),
  //                           onPressed: (){
  //                             Navigator.of(context).pop();
  //                           },
  //                         ),
  //                         Text("https://system.com/auth/login",style: TextStyle(
  //                             fontSize:14,color: Colors.black87),),
  //                         SizedBox(width: 6,),
  //                         Icon(Icons.lock,color: Colors.black87,),
  //
  //                       ],),
  //                   ),
  //                 ),
  //                 CustomWebView(),
  //               ],
  //             )
  //         )  ,
  //
  //       ),
  //     );
  //   });
  // }
}
