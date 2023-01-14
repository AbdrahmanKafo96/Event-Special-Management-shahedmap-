import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shahed/models/event.dart';
import 'package:shahed/modules/home/menu/view_screen.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:http/http.dart' as http;
import 'package:shahed/widgets/custom_indecator.dart';

import '../../../widgets/customDirectionality.dart';

class DataSearchSe extends SearchDelegate<String> {
  List<dynamic>? listName;
  List<Event>? futureList;
  String? eventName;
  int? eventId;

  DataSearchSe({this.listName, this.futureList});

  @override
  String get searchFieldLabel => SharedData.getGlobalLang().searchByName();

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for appbar
    return [
      IconButton(
          tooltip: SharedData.getGlobalLang().cancelSearch(),
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () => query = "")
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icon leading
    return IconButton(
        tooltip: SharedData.getGlobalLang().back(),
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          close(context,'');
        });
  }

  Future fetchSearchedEvent() async {
    print('inside ${eventId}');
    Map data = {
      'addede_id': eventId.toString(),
    };
    final storage = await SharedClass.getStorage();
    String? value = await storage.read(
        key: "token", aOptions: SharedClass.getAndroidOptions());
    final response = await http.post(
        Uri.parse('${SharedClass.apiPath}/getEvent'),
        body: data,
        headers: {
          // 'Accept':'application/json',
          'Authorization': 'Bearer $value',
          // 'content-type': 'application/json',
        });

    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);

      return parsed;
    } else {
      throw Exception('Failed to load List');
    }
  }

  // @override
  // Widget buildResults(BuildContext context) {
  //   // result search...
  //
  //   return FutureBuilder(
  //     future: fetchSearchedEvent(),
  //     builder: (context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData) {
  //         return customDirectionality(
  //           child: ListView.builder(
  //               itemCount: 1,
  //               itemBuilder: (context, index) {
  //                 return Column(
  //                   children: [
  //                     Container(
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(15.0),
  //                         ),
  //                         padding: EdgeInsets.only(top: 8),
  //                         child: Card(
  //                             color: Color(0xFF424250),
  //                             shape: RoundedRectangleBorder(
  //                               side: BorderSide(
  //                                 color: Color(0xFF424250),
  //                               ),
  //                               borderRadius: BorderRadius.circular(15.0),
  //                             ),
  //                             child: ListTile(
  //                                 onTap: () {
  //                                   checkInternetConnectivity(context)
  //                                       .then((bool value) async {
  //                                     if (value) {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (context) => EventView(
  //                                                   eventID: futureList[index]
  //                                                       .addede_id as int,
  //                                                   eventName:
  //                                                       snapshot.data['data']
  //                                                           ['event_name'],
  //                                                 )),
  //                                       );
  //                                     }
  //                                   });
  //                                 },
  //                                 trailing: SizedBox(
  //                                   width: 100,
  //                                   child: Row(
  //                                     children: [
  //                                       IconButton(
  //                                         tooltip: SharedData.getGlobalLang()
  //                                             .updateEvent(),
  //                                         icon: Icon(
  //                                           Icons.edit,
  //                                           color: Colors.deepOrange,
  //                                         ),
  //                                         onPressed: () {
  //                                           checkInternetConnectivity(context)
  //                                               .then((bool value) async {
  //                                             if (value) {
  //                                               Navigator.push(
  //                                                 context,
  //                                                 MaterialPageRoute(
  //                                                     builder: (context) => EventView(
  //                                                         eventID:
  //                                                             futureList[index]
  //                                                                     .addede_id
  //                                                                 as int,
  //                                                         eventName: snapshot
  //                                                                 .data['data']
  //                                                             ['event_name'])),
  //                                               );
  //                                             }
  //                                           });
  //                                         },
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 leading: Icon(
  //                                   Icons.event_note_rounded,
  //                                   size: 30,
  //                                   color: Colors.amber.shade200,
  //                                 ),
  //                                 title: Text(
  //                                   '${snapshot.data['data']['event_name']}',
  //                                   style:
  //                                       Theme.of(context).textTheme.bodyText1,
  //                                 )))),
  //                     Divider(
  //                       color: Colors.grey,
  //                     )
  //                   ],
  //                 );
  //               }),
  //         );
  //       }
  //       return Center(
  //         child: customCircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }

// working fine
  @override
  Widget buildSuggestions(BuildContext context) {

    List<Event> searchList = futureList
        !.where((element) =>
            element.event_name!.toLowerCase()!.contains(query.toLowerCase()))
        .toList();

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ListView.builder(
            itemCount: query == null ? futureList!.length : searchList.length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.only(top: 8),
                  child: Card(
                      color: Color(0xFF424250),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xFF424250),
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        // tileColor: Color(0xFF424250),
                        //leading: Image.network('${imgLinks}'),
                        leading: Icon(
                          Icons.event_note_rounded,
                          color: Colors.grey.shade200,
                        ),
                        title: Text(
                          "${searchList[index].event_name}",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        onTap: () {

                           eventId = query == null
                               ? futureList![index].addede_id as int
                               : searchList[index].addede_id as int;
                           eventName = query == null
                               ? futureList![index].event_name
                               : searchList[index].event_name;

                          showResults(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => EventView(
                          //           eventID: query == null
                          //               ? futureList[index].addede_id as int
                          //               : searchList[index].addede_id as int,
                          //           eventName: query == null
                          //               ? futureList[index].event_name
                          //               : searchList[index].event_name)),
                          // );
                        },
                      )));
            }));
  }

  @override
  Widget buildResults(BuildContext context) {
     return EventView(
         eventID:eventId,
         eventName:eventName,
         state: 1,
     );
  }
}
