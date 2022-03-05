import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:systemevents/models/Category.dart';
import 'package:systemevents/modules/home/event_screens/map_screen.dart';
import 'package:systemevents/modules/home/event_screens/new_file.dart';
 import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/shimmer/shimmer.dart';
import 'package:systemevents/singleton/singleton.dart';

class ResponsePage extends StatefulWidget {
  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  Future<List<Respo>> fuList;
  List<Respo>   futureList=[];
  int user_id;

  @override
  initState() {
    super.initState();
     getData();

  }
  Future<void> getData()   {
    Singleton.getPrefInstance().then((value) {
      setState(() {
        user_id=value.getInt('user_id');
        //  value.getInt('user_id')
        fuList = Provider.of<EventProvider>(context, listen: false)
            .getAllRespons(value.getInt('user_id'));
      });
    });
    Future.delayed(const Duration(seconds: 1), () {

    });
  }

  // Widget slideRightBackground() {
  //   return Container(
  //     color: Colors.green,
  //     child: Align(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           SizedBox(
  //             width: 20,
  //           ),
  //           Icon(
  //             Icons.edit,
  //             color: Colors.white,
  //           ),
  //           Text(
  //             "تعديل",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w700,
  //             ),
  //             textAlign: TextAlign.left,
  //           ),
  //         ],
  //       ),
  //       alignment: Alignment.centerLeft,
  //     ),
  //   );
  // }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "حذف",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  generateItemsList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Respo>>(
          future: fuList ,
          builder: (context, snapshot) {
            // if(!snapshot.hasData){
            //   return Center(child: CircularProgressIndicator());
            // }

            // if ( snapshot.data==null)
            //   return Center(child: Text('قم بإنشاء حدث جديد'));
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('');

              case ConnectionState.waiting:
                return  ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) =>   NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),
                );

              case ConnectionState.active:
                return  ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) =>   NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),
                );

              case ConnectionState.done:
                return snapshot.hasData
                    ? RefreshIndicator(
                  displacement: 5,
                      onRefresh: getData,
                      child: ListView.builder(
                        shrinkWrap: true,

                        itemCount: snapshot.data.length,
                        // separatorBuilder: (context, index) => Divider(
                        //   color: Colors.black,
                        // ),
                        itemBuilder: (context, index) {
                         return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                             InkWell(


                                onTap: (){},
                                child: Ink(
                                  color: snapshot.data[index].seen==0 ?Colors.grey.withOpacity(0.5):
                                  Colors.white,
                                  child: ListTile(
                                      onTap: () {
                                        Provider.of<EventProvider>(context, listen: false)
                                            .updateNoti( user_id,snapshot.data[index].notification_id).
                                        then((value){
                                          Provider.of<EventProvider>(context, listen: false)
                                              .getRespo( user_id,snapshot.data[index].notification_id).then((value){
                                            print(value['data']['lat']);
                                            print(value['data']['lng']);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>

                                                      MapMap(
                                                          lat: value['data']['lat'] ,
                                                          lng:value['data']['lng'])),
                                            );
                                          });
                                        });

                                      },
                                      // trailing: IconButton(
                                      //     tooltip: 'حذف الحدث',
                                      //     icon: Icon(
                                      //       Icons.delete,
                                      //       color: Colors.red,
                                      //     ),
                                      //     onPressed: () {
                                      //       // return customAlertForButton(
                                      //       //     snapshot
                                      //       //         .data[index].addede_id,
                                      //       //     snapshot,
                                      //       //     index,
                                      //       //     context);
                                      //     }),

                                      leading: Icon(
                                        Icons.event_note_rounded,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      title: Text(
                                        '${snapshot.data[index].type_name}',
                                        style:
                                        TextStyle(color: Color(0xFF666666)),
                                      )),
                                ),

                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                      );

                  },
                ),
                    )
                    : Center(child: Text('لا توجد إستجابات للعرض' ,style: Theme.of(context).textTheme.subtitle1));
                    default:
                      {
                        return Center(child: Text('لا توجد إستجابات للعرض' ,style: Theme.of(context).textTheme.subtitle1));
                      }
            }
            return null; // unreachable
          }),
    );
  }

  customAlertForButton(
      int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            child: customAlert(addede_id, snapshot, index, context),
            textDirection: TextDirection.rtl,
          );
        });
  }

  AlertDialog customAlert(
      int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
    return AlertDialog(
      content: Text("؟هل انت متأكد من حذف الحدث "),
      actions: <Widget>[
        TextButton(
          child: Text(
            "إلغاء",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "حذف",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            var postId = addede_id;

            Singleton.getPrefInstance().then((value) {
              Provider.of<EventProvider>(context, listen: false)
                  .deleteEvent(postId, value.getInt('user_id'));
            });

            setState(() {
              snapshot.data.removeAt(index);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

        appBar: AppBar(
          actions: [
            // IconButton(
            //     tooltip: 'بحث',
            //     icon: Icon(
            //       Icons.search_rounded,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {
            //       // showSearch(context: context,
            //       //     delegate: DataSearchSe(listName: listNames,futureList: futureList));
            //     }),

          ],
          centerTitle: true,
          elevation: 1.0,
          titleSpacing: 1.0,
          title: Text(
            "الاستجابات" ,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: generateItemsList(),
      ),
    );
  }
}


