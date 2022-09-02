import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:systemevents/models/event.dart';
import 'package:systemevents/modules/home/menu/view_screen.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/shimmer/shimmer.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/checkInternet.dart';

class EventsMenu extends StatefulWidget {
  @override
  _EventsMenuState createState() => _EventsMenuState();
}

class _EventsMenuState extends State<EventsMenu> {
  Future<List<Event>> fuList;
  List<Event> futureList = [];
  List<dynamic> listNames = [];
  bool result =true;
  @override
  initState() {
    super.initState();
    Connectivity().checkConnectivity().then((  value) {

      if(value== ConnectivityResult.none){
        setState(() {
          result=false;
        });

      }else{
        getData();
        fetchData();
      }
    });

  }
  Future<void> fetchData() async{
    // await Future.delayed(Duration(milliseconds: 1500));
    // setState(() {
      Singleton.getPrefInstance().then((value) {
        setState(() {
          //  value.getInt('user_id')
          fuList = Provider.of<EventProvider>(context, listen: false)
              .fetchAllListByUserId(value.getInt('user_id'));
        });

    });

  }
  Future<void> getData() {
    var list;
    Singleton.getPrefInstance().then((value) async {
      list = await Provider.of<EventProvider>(context, listen: false)
          .searchData(value.getInt('user_id'));
            try{
              if (list != false  )
                for (int i = 0; i < list.length; i++) {
                  listNames.add(list[i]['event_name']);
                  futureList.add(Event(
                      addede_id: list[i]['addede_id'],
                      event_name: list[i]['event_name'],
                      description:list[i]['event_name']==null?"":list[i]['event_name'] ));
                }
            }catch(e){

      }

    });
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "تعديل",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

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
              textAlign: TextAlign.center,
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
    return FutureBuilder<List<Event>>(
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
                    onRefresh:fetchData ,
                    child: ListView.builder(
                        shrinkWrap: true,

                        itemCount: snapshot.data.length,
                        // separatorBuilder: (context, index) => Divider(
                        //   color: Colors.black,
                        // ),
                        itemBuilder: (context, index) {
                          return Dismissible(
                              // ignore: missing_return
                              confirmDismiss: (DismissDirection direction) async {
                                //  if (direction == DismissDirection.startToEnd) {
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: customAlert(
                                            snapshot.data[index].addede_id,
                                            snapshot,
                                            index,
                                            context),
                                      );
                                    });
                                return res;
                                // } else {
                                //
                                // }
                              },
                              // background: slideRightBackground(),
                              background: slideLeftBackground(),
                              key: Key(index.toString()),
                              child: Column(
                                children: [
                                  Container(

                                    padding: EdgeInsets.only(top: 8),
                                    child: Card(
                                      color: Colors.white  ,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.grey.shade50 ,
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
                                                            eventID: snapshot
                                                                .data[index]
                                                                .addede_id,
                                                            eventName: snapshot
                                                                .data[index]
                                                                .event_name,
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
                                                  tooltip: 'تعديل الحدث',
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
                                                                      eventID: snapshot
                                                                          .data[index]
                                                                          .addede_id,
                                                                      eventName: snapshot
                                                                          .data[index]
                                                                          .event_name)),
                                                        );
                                                      }
                                                    });
                                                  },
                                                ),
                                                IconButton(
                                                    tooltip: 'حذف الحدث',
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      checkInternetConnectivity(
                                                              context)
                                                          .then((bool value) async {
                                                        if (value) {
                                                          return customAlertForButton(
                                                              snapshot.data[index]
                                                                  .addede_id,
                                                              snapshot,
                                                              index,
                                                              context);
                                                        }
                                                      });
                                                    })
                                              ],
                                            ),
                                          ),
                                          leading: Icon(
                                            Icons.event_note_rounded,
                                            size: 30,
                                            color: Colors.blueGrey,
                                          ),
                                          title: Text(
                                            '${snapshot.data[index].event_name}',
                                            softWrap: true,
                                            //overflow: TextOverflow.visible,
                                            style:
                                                TextStyle(color: Color(0xFF666666),fontWeight:FontWeight.bold,
                                                fontSize: 14),
                                          ),subtitle: Text(
                                        '${snapshot.data[index].description}',
                                        softWrap: true,
                                        //overflow: TextOverflow.visible,

                                        style:
                                        TextStyle( fontWeight:FontWeight.normal,
                                            fontSize: 12),
                                      ),),
                                    ),
                                  ),
                                  // Divider(
                                  //   color: Colors.grey,
                                  // )
                                ],
                              ));
                        },
                      ),
                  )
                  : Container(
                      child: Center(child: Column(
                        children: [
                          Image( image: AssetImage('assets/images/emptyimage.png') ,width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height*0.4,  ),
                          Text('يجب ان تنشئ حدث جديد' ,style: Theme.of(context).textTheme.subtitle1,)
                        ],
                      ),),
              );
            default:
              {
                return Center(child: Text('انشئ حدث جديد' ,style: Theme.of(context).textTheme.subtitle1));
              }
          }
          return null; // unreachable
        });
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00695C) ,
                    Color(0xFF4DB6AC),
                  ],
                )),
          ),
          actions: [
            IconButton(
                tooltip: 'بحث',
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: DataSearchSe(
                          listName: listNames, futureList: futureList));
                }),
          ],
          centerTitle: true,
          elevation: 1.0,
          titleSpacing: 1.0,
          title: Text(
            "الاحداث",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body:  result==true? generateItemsList():
        Container(
          child: Center(child: Image( image: AssetImage('assets/images/wifi.png') ,width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.4,  ),),
        ),
      ),
    );
  }
}

class DataSearchSe extends SearchDelegate<String> {
  List<dynamic> listName;
  List<Event> futureList;
  String eventName;
  static int eventId;

  DataSearchSe({this.listName, this.futureList});

  @override
  String get searchFieldLabel => 'ابحث باسم الحدث';

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for appbar
    return [
      IconButton(
          tooltip: 'إلغاء البحث',
          icon: Icon(Icons.clear),
          onPressed: () => query = "")
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icon leading
    return IconButton(
        tooltip: "رجوع",
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
    final storage = await Singleton.getStorage()  ;
    String value = await storage.read(key: "token" ,aOptions: Singleton.getAndroidOptions());
    final response =
        await http.post(Uri.parse('${Singleton.apiPath}/getEvent'), body: data ,headers: {
          // 'Accept':'application/json',
          'Authorization' : 'Bearer $value',
          // 'content-type': 'application/json',
        } );

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
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                        onTap: () {
                          checkInternetConnectivity(context)
                              .then((bool value) async {
                            if (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventView(
                                          eventID: eventId,
                                          eventName: snapshot.data['data']
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
                                tooltip: 'تعديل الحدث',
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
                                            builder: (context) => EventView(
                                                eventID: eventId,
                                                eventName: snapshot.data['data']
                                                    ['event_name'])),
                                      );
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                  tooltip: 'حذف الحدث',
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    checkInternetConnectivity(context)
                                        .then((bool value) async {
                                      if (value) {
                                        return customAlertForButton(
                                            snapshot.data[index].addede_id,
                                            snapshot,
                                            index,
                                            context);
                                      }
                                    });
                                  })
                            ],
                          ),
                        ),
                        leading: Icon(
                          Icons.event_note_rounded,
                          size: 30,
                          color: Colors.blueGrey,
                        ),
                        title: Text(
                          '${snapshot.data['data']['event_name']}',
                          style: TextStyle(color: Color(0xFF666666)),
                        )),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                );
              });
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  //leading: Image.network('${imgLinks}'),
                  leading: Icon(Icons.event_note_rounded),
                  title: Text("${searchList[index]}"),
                  onTap: () {
                    checkInternetConnectivity(context).then((bool value) async {
                      if (value) {
                        eventId = futureList[index].addede_id;

                        showResults(context);
                      }
                    });
                  },
                );
              })),
    );
  }

  customAlertForButton(
      int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            child: _EventsMenuState()
                .customAlert(addede_id, snapshot, index, context),
            textDirection: TextDirection.rtl,
          );
        });
  }
}
