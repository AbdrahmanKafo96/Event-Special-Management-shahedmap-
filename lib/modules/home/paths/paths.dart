import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/path.dart';
import 'package:shahed/modules/home/tracking/mission.dart';

import '../../../models/category.dart';
import '../../../provider/event_provider.dart';
import '../../../shared_data/shareddata.dart';
import '../../../shimmer/shimmer.dart';
import '../../../singleton/singleton.dart';
import '../../../widgets/custom_app_bar.dart';


class Paths extends StatefulWidget {

  @override
  State<Paths> createState() => _PathListState();
}

class _PathListState extends State<Paths> {
  Future<List<Path>> fuList;
  List<Path> futureList = [];
  int user_id;

  @override
  initState() {
    super.initState();
    getData();
  }

  Future<List<Path>> getData() {
    SharedClass.boxPath().then((value) {
      List keys;
      keys=value.keys.map((e) =>e).toList();

      List values;
      values=value.values.map((e) =>e).toList();

      for(int i=0; i<keys.length;i++){
        futureList.add(Path(title: keys.elementAt(i) as String ,points:values[i] as List));
      }
      futureList.forEach((element) {print(element.title);});
     setState(() {
       futureList;
     });

    });
    Future.delayed(const Duration(seconds: 1), () {});
  }

  // Widget slideLeftBackground() {
  //   return Container(
  //     color: Colors.red,
  //     child: Align(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           Icon(
  //             Icons.delete,
  //             color: Colors.white,
  //           ),
  //           Text(
  //             SharedData.getGlobalLang().delete(),
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w700,
  //             ),
  //             textAlign: TextAlign.right,
  //           ),
  //           SizedBox(
  //             width: 20,
  //           ),
  //         ],
  //       ),
  //       alignment: Alignment.centerRight,
  //     ),
  //   );
  // }

  generateItemsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child:  RefreshIndicator(
                  displacement: 5,
                  onRefresh: getData,
                  child: ListView.builder(
                    shrinkWrap: true,

                    itemCount:futureList.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Ink(
                                child: Card(
                                  color:  Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.green.shade300,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>  UserMission(
                                                path: futureList[index].points ,
                                                state: 0, pathshasData: 'yes',)
                                          ),
                                        );
                                      },
                                      leading: Icon(
                                        Icons.polyline,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      title: Text(
                                        '${SharedData.getGlobalLang().path()} ${futureList[index].title.replaceAll(new RegExp(r"\d"), "")}',
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


    );
  }

  // customAlertForButton(
  //     int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return customAlert(addede_id, snapshot, index, context);
  //       });
  // }

  // AlertDialog customAlert(
  //     int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
  //   return AlertDialog(
  //     content: Text(SharedData.getGlobalLang().alertDeleteEvent()),
  //     actions: <Widget>[
  //       TextButton(
  //         child: Text(
  //           SharedData.getGlobalLang().cancel(),
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //       TextButton(
  //         child: Text(
  //           SharedData.getGlobalLang().delete(),
  //           style: TextStyle(color: Colors.red),
  //         ),
  //         onPressed: () {
  //           var postId = addede_id;
  //
  //           SharedClass.getBox().then((value) {
  //             Provider.of<EventProvider>(context, listen: false)
  //                 .deleteEvent(postId, value.get('user_id'));
  //           });
  //
  //           setState(() {
  //             snapshot.data.removeAt(index);
  //           });
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: SharedData.getGlobalLang().pathList(),
          icon: FontAwesomeIcons.drawPolygon),
       body: generateItemsList(),
   //   body: Container(),
    );
  }
}
