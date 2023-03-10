import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shahed/models/category.dart';
import 'package:shahed/modules/home/responses/map_respo.dart';
import 'package:shahed/provider/counter_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/shimmer/shimmer.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';

import '../../../theme/colors_app.dart';

class ResponsePage extends StatefulWidget {
  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  Future<List<Respo?>?>? fuList;
  List<Respo>? futureList = [];
  int? user_id;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<CounterProvider>(context ,listen: false).setCounterNotification=false;
    });
    getData();
  }

  Future<void> getData() async{
    SharedClass.getBox().then((value) {
      setState(() {
        user_id = value.get('user_id');

        fuList = Provider.of<EventProvider>(context, listen: false)
            .getAllRespons(value.get('user_id'));
      });
    });
    Future.delayed(const Duration(seconds: 1), () {});
  }

  Widget slideLeftBackground() {
    return Container(
      color: SharedColor.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: SharedColor.white,
            ),
            Text(
              SharedData.getGlobalLang().delete(),
              style: TextStyle(
                color: SharedColor.white,
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
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder<List<Respo?>?> (
          future: fuList,
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
                return ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) => NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                );

              case ConnectionState.active:
                return ListView.separated(
                  itemCount: 5,
                  itemBuilder: (context, index) => NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                );

              case ConnectionState.done:
                return snapshot.hasData && snapshot.data!.length > 0
                    ? RefreshIndicator(
                        displacement: 5,
                        color: SharedColor.deepOrange,
                        onRefresh: getData,
                        child: ListView.builder(
                          shrinkWrap: true,

                          itemCount: snapshot.data!.length,
                          // separatorBuilder: (context, index) => Divider(
                          //   color: SharedColor.black,
                          // ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Ink(
                                      child: Card(
                                        color: snapshot.data![index]!.seen  == 0
                                            ? SharedColor.grey.withOpacity(0.5)
                                            : SharedColor.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: SharedColor.green,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                            onTap: () {
                                              if (snapshot.data![index]!.seen ==
                                                  0) {
                                                Provider.of<EventProvider>(
                                                        context,
                                                        listen: false)
                                                    .updateNoti(
                                                        user_id!,
                                                        snapshot!.data![index]
                                                            !.notification_id!)
                                                    .then((value1) {
                                                  Provider.of<EventProvider>(
                                                          context,
                                                          listen: false)
                                                      .getRespo(
                                                          user_id!,
                                                          snapshot.data![index]
                                                              !.notification_id!)
                                                      .then((value) {
                                                    print(value['data']['lat']);
                                                    print(value['data']['lng']);
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) => Mappoly(
                                                            lat: double.parse(
                                                                value['data']
                                                                ['lat']),
                                                            lng: double.parse(
                                                                value['data'][
                                                                'lng'])),
                                                        transitionDuration: Duration.zero,
                                                      ),

                                                    );
                                                  });
                                                });
                                              } else {
                                                Provider.of<EventProvider>(
                                                        context,
                                                        listen: false)
                                                    .getRespo(
                                                        user_id!,
                                                        snapshot.data![index]
                                                            !.notification_id!)
                                                    .then((value) {
                                                  print(value['data']['lat']);
                                                  print(value['data']['lng']);
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (_, __, ___) =>  Mappoly(
                                                          lat: double.parse(
                                                              value['data']
                                                              ['lat']),
                                                          lng: double.parse(
                                                              value['data']
                                                              ['lng'])),
                                                      transitionDuration: Duration.zero,
                                                    ),

                                                  );
                                                });
                                              }
                                            },
                                            leading: Icon(
                                              Icons.event_note_rounded,
                                              size: 30,
                                              color: SharedColor.blueGrey,
                                            ),
                                            title: Text(
                                              '${snapshot.data![index]!.type_name!}',
                                              style: TextStyle(
                                                  color: Color(0xFF666666)),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                            SharedData.getGlobalLang().noNotifications(),
                            style: TextStyle(color: SharedColor.black54)));
              default:
                {
                  return Center(
                      child: Text(SharedData.getGlobalLang().noNotifications(),
                          style: TextStyle(color: SharedColor.black54)));
                }
            }
          }),
    );
  }

  customAlertForButton(
      int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return customAlert(addede_id, snapshot, index, context);
        });
  }

  AlertDialog customAlert(
      int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
    return AlertDialog(
      content: Text(SharedData.getGlobalLang().alertDeleteEvent()),
      actions: <Widget>[
        TextButton(
          child: Text(
            SharedData.getGlobalLang().cancel(),
            style: TextStyle(color: SharedColor.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            SharedData.getGlobalLang().delete(),
            style: TextStyle(color: SharedColor.red),
          ),
          onPressed: () {
            var postId = addede_id;

            SharedClass.getBox().then((value) {
              Provider.of<EventProvider>(context, listen: false)
                  .deleteEvent(postId, value.get('user_id'));
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
    return Scaffold(
      appBar: customAppBar(context,
          title: SharedData.getGlobalLang().notifications(),
          icon: FontAwesomeIcons.solidBell),
      body: generateItemsList(),
    );
  }
}
