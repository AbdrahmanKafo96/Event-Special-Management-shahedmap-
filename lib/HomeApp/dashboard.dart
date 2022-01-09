import 'package:flutter/material.dart';
import 'package:systemevents/CustomWidget/customCard.dart';
import 'package:systemevents/webBrowser/webView.dart';

class Dashboard extends StatelessWidget {


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
            dashboardItem(context,"تصفح الموقع", Icons.language,'browser'),
            // dashboardItem(context,"تغيير خلفية التطبيق", Icons.nights_stay,'ThemeApp'),
            // dashboardItem(context,"حول التطبيق", Icons.info,'About'),
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
      //highlightColor: Colors.blueGrey,
      //hoverColor: Colors.black,
      onTap: () {
        if(routName!="browser")
        viewPage(ctx ,routName);
        else{
          bottomSheet(ctx);
        }
      },
      child:customCard(icon , title),
    );
  }
  void bottomSheet(BuildContext context){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder:(context){
      return Container(
        color: Color(0xFF737373),
        height: MediaQuery.of(context).size.height-100,
        child: Container(
          height: MediaQuery.of(context).size.height-100,
          // height: MediaQuery.of(context).size.height-100,

          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              )
          ),
          child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding:  const EdgeInsets.all(5.0),
                      margin:const EdgeInsets.all(5.0),
                      //color: Colors.green,
                      child: Row(
                        children: [
                          IconButton(

                            icon:Text("خروج",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14 , color: Colors.blue),),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                          Text("https://system.com/auth/login",style: TextStyle(
                              fontSize:14,color: Colors.black87),),
                          SizedBox(width: 6,),
                          Icon(Icons.lock,color: Colors.black87,),

                        ],),
                    ),
                  ),
                  CustomWebView(),
                ],
              )
          )  ,

        ),
      );
    });
  }
}
