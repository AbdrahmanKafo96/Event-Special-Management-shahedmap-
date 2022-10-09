import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/tracking/unit_tracking.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/shimmer/shimmer.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../models/mission.dart';

class Missions extends StatefulWidget {
  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  // Future<List<Respo>> fuList;
  Future<List<Mission>> futureList;

  @override
  initState() {
    super.initState();
    getData();
  }

  String user_id, ben_id;

  Future<void> getData() {
    SharedClass.getBox().then((value) async {
      setState(() {
        user_id = value.get('user_id').toString();
        ben_id = value.get('beneficiarie_id').toString();
        futureList = Provider.of<EventProvider>(context, listen: false)
            .getMissions(user_id, ben_id);
      });
    });
    Future.delayed(const Duration(seconds: 1), () {});
  }

  generateItemsList() {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder<List<Mission>>(
            future: futureList,
            builder: (ctx, snapshot) {
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
                  return snapshot.hasData && snapshot.data.length > 0
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
                                      onTap: () {},
                                      child: Ink(
                                        child: Card(
                                          color: snapshot.data[index].seen == 0
                                              ? Colors.grey.withOpacity(0.5)
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.green.shade300,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: ListTile(
                                              onTap: () {
                                                if(snapshot.data[index].seen == 0){
                                                  Provider.of<EventProvider>(
                                                      context,
                                                      listen: false)
                                                      .updateMissionSeen(
                                                      user_id,
                                                      snapshot.data[index]
                                                          .mission_id
                                                          .toString())
                                                      .then((value) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UnitTracking()),
                                                    );
                                                  });
                                                }else{
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UnitTracking()),
                                                  );
                                                }

                                              },
                                              subtitle: Text(
                                                '${snapshot.data[index].mission_date}',
                                                style: TextStyle(
                                                    color: Color(0xFF666666)),
                                              ),
                                              leading: Icon(
                                                Icons.event_note_rounded,
                                                size: 30,
                                                color: Colors.blueGrey,
                                              ),
                                              title: Text(
                                                '${snapshot.data[index].mission_name}',
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
                              style: TextStyle(color: Colors.black54)));
                default:
                  {
                    return Center(
                        child: Text(
                            SharedData.getGlobalLang().noNotifications(),
                            style: TextStyle(color: Colors.black54)));
                  }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: SharedData.getGlobalLang().missionsList(),
          icon: FontAwesomeIcons.locationDot),
      body: generateItemsList(),
    );
  }
}
