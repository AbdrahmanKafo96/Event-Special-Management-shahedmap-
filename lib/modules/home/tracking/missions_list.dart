import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/tracking/BrowserMap.dart';
import 'package:shahed/provider/counter_provider.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/shimmer/shimmer.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/mission.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../theme/colors_app.dart';
//import 'mission_track.dart';

class Missions extends StatefulWidget {
  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  // Future<List<Respo>> fuList;
  Future<List<Mission?>?>?  futureList;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<CounterProvider>(context ,listen: false).setCounterMissions=false;
    });
     getData();
  }

  String? user_id, ben_id;
  Future<void> getData() async {

        SharedClass.getBox().then((value) async {
        setState(() {
          user_id = value.get('user_id').toString();
          ben_id = value.get('beneficiarie_id').toString();
          futureList = Provider.of<EventProvider>(context, listen: false)
              .getMissions(user_id!, ben_id);
        });

    });

  }

  generateItemsList() {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder<List<Mission?>?>(
            future:futureList ,
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
                  return snapshot.hasData && snapshot.data!.length > 0
                      ? RefreshIndicator(
                          displacement: 5,
                          color: SharedColor.orange,
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
                                    Card(
                                      color: snapshot.data![index]!.seen == 0
                                          ? Color(SharedColor.whiteIntColor)
                                          : Color(SharedColor.greyIntColor),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                snapshot.data![index]!.seen == 0
                                                    ? SharedColor.black54
                                                    : SharedColor.white12),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          if (snapshot.data![index]!.seen == 0) {
                                            Provider.of<EventProvider>(context,
                                                    listen: false)
                                                .updateMissionSeen(
                                                    user_id!,
                                                    snapshot
                                                        .data![index]!.mission_id
                                                        .toString())
                                                .then((value) {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>   BrowserMap(
                                                    latLngDestination: LatLng(
                                                        snapshot
                                                            .data![index]
                                                        !.lat_finish!,
                                                        snapshot
                                                            .data![index]
                                                        !.lng_finish!),
                                                    state: 1,
                                                    pathshasData: 'yes',
                                                    path: snapshot
                                                        .data![index]!.points ,
                                                  ),
                                                  transitionDuration: Duration.zero,
                                                ),

                                              );
                                            });
                                          } else {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>  BrowserMap(
                                                  latLngDestination: LatLng(
                                                      snapshot
                                                          .data![index]!
                                                          .lat_finish!,
                                                      snapshot
                                                          .data![index]!
                                                          .lng_finish!),
                                                  state: 1,
                                                  pathshasData: 'yes',
                                                  path: snapshot
                                                      .data![index]
                                                  !.points,
                                                ),
                                                transitionDuration: Duration.zero,
                                              ),

                                            );
                                          }
                                        },
                                        subtitle: Text(
                                          '${snapshot.data![index]!.mission_date }',
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: snapshot.data![index]!.seen == 0
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                              : Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                        ),
                                        leading: Icon(
                                          Icons.task_alt,
                                          size: 30,
                                          color: snapshot.data![index]!.seen == 0
                                              ? SharedColor.green
                                              : SharedColor.white,
                                        ),
                                        title: Text(
                                          '${snapshot.data![index]!.mission_name}',
                                          softWrap: true,
                                          //overflow: TextOverflow.visible,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
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
                        child: Text(
                            SharedData.getGlobalLang().noNotifications(),
                            style: TextStyle(color: SharedColor.black54)));
                  }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: SharedData.getGlobalLang().missionsList(),
          icon: FontAwesomeIcons.solidComment),
      body: generateItemsList(),
    );
  }
}
