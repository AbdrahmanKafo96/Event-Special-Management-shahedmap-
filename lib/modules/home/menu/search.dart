import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shahed/models/event.dart';
import 'package:shahed/modules/home/menu/view_screen.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/customDirectionality.dart';

class DataSearchSe extends SearchDelegate<String> {
  List<dynamic> listName;
  List<Event> futureList;
  String eventName;
  static int eventId;

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
          color: Colors.black,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  Future fetchSearchedEvent() async {
    Map data = {
      'addede_id': eventId.toString(),
    };
    final storage = await Singleton.getStorage();
    String value = await storage.read(
        key: "token", aOptions: Singleton.getAndroidOptions());
    final response = await http
        .post(Uri.parse('${Singleton.apiPath}/getEvent'), body: data, headers: {
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

  @override
  Widget buildResults(BuildContext context) {
    // result search...

    return FutureBuilder(
      future: fetchSearchedEvent(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print("eventId $eventId");
          return customDirectionality(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return   Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                    onTap: () {
                                      checkInternetConnectivity(context)
                                          .then((bool value) async {
                                        if (value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EventView(
                                                      eventID: eventId,
                                                      eventName:
                                                          snapshot.data['data']
                                                              ['event_name'],
                                                    )),
                                          );
                                        }
                                      });
                                    },
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            tooltip: SharedData.getGlobalLang().updateEvent(),
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              checkInternetConnectivity(context)
                                                  .then((bool value) async {
                                                if (value) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EventView(
                                                                eventID: eventId,
                                                                eventName: snapshot
                                                                            .data[
                                                                        'data'][
                                                                    'event_name'])),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.event_note_rounded,
                                      size: 30,
                                      color: Colors.grey.shade200,
                                    ),
                                    title: Text(
                                      '${snapshot.data['data']['event_name']}',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    )))),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                  );
                }),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //show when someone searchers for something...
    var searchList = query.isEmpty
        ? listName
        : listName.where((element) => element.startsWith(query)).toList();

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

          child: ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            "${searchList[index]}",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          onTap: () {
                            checkInternetConnectivity(context)
                                .then((bool value) async {
                              if (value) {
                                eventId = futureList[index].addede_id;
                                showResults(context);
                              }
                            });
                          },
                        )));
              }
        ) );
  }
}
