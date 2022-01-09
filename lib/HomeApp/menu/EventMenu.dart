import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/HomeApp/menu/EventView.dart';
import 'package:http/http.dart' as http;
import 'package:systemevents/model/Event.dart';
import 'package:systemevents/provider/EventProvider.dart';
import 'package:systemevents/singleton/singleton.dart';

class EventsMenu extends StatefulWidget {
  @override
  _EventsMenuState createState() => _EventsMenuState();
}

class _EventsMenuState extends State<EventsMenu> {
  Future<List<Event>> fuList;
   List<Event>   futureList=[];
   List<dynamic>   listNames=[];

  @override
  initState() {
    super.initState();
    getData();
    Singleton.getPrefInstace().then((value) {
      setState(() {
        //  value.getInt('user_id')
        fuList = Provider.of<EventProvider>(context, listen: false)
            .fetchAllListByUserId(value.getInt('user_id'));
      });
    });
  }
  Future getData()   {
    var  list;
    Singleton.getPrefInstace().then((value) async {
      list =    await Provider.of<EventProvider>(context, listen: false)
          .searchByName(value.getInt('user_id'));

      if(list!=false)
        for(int i=0 ;i <list.length; i ++)
        {
          listNames.add(list[i]['event_name']);
          futureList.add(Event(addede_id:list[i]['addede_id'] , event_name:list[i]['event_name'] ));
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
              return Center(child: CircularProgressIndicator());

            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              return snapshot.hasData
                  ? ListView.builder(
                      shrinkWrap: true,

                      itemCount: snapshot.data.length,
                      // separatorBuilder: (context, index) => Divider(
                      //   color: Colors.black,
                      // ),
                      itemBuilder: (context, index) {
                        return Dismissible(
                            // ignore: missing_return
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.endToStart) {
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
                              } else {
                                // TODO: Navigate to edit page;
                              }
                            },
                             background: slideRightBackground(),
                            secondaryBackground: slideLeftBackground(),
                            key: Key(index.toString()),
                            child: Column(
                              children: [
                                ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EventView(eventID: snapshot.data[index].addede_id,)),
                                      );
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
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => EventView(eventID: snapshot.data[index].addede_id,)),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            tooltip: 'حذف الحدث',
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                return customAlertForButton(
                                                    snapshot
                                                        .data[index].addede_id,
                                                    snapshot,
                                                    index,
                                                    context);
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
                                      style:
                                          TextStyle(color: Color(0xFF666666)),
                                    )),
                                Divider(
                                  color: Colors.grey,
                                )
                              ],
                            ));
                      },
                    )
                  : Center(child: Text('انشئ حدث جديد'));
            default:
              {
                return Center(child: Text('انشئ حدث جديد'));
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

            Singleton.getPrefInstace().then((value) {
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
            IconButton(
                tooltip: 'بحث',
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  showSearch(context: context,
                      delegate: DataSearchSe(listName: listNames,futureList: futureList));
                }),

          ],
          centerTitle: true,
          elevation: 1.0,
          titleSpacing: 1.0,
          title: Text(
              "الاحداث" ,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: generateItemsList(),
      ),
    );
  }

}
class DataSearchSe extends SearchDelegate<String> {
  List<dynamic>   listName;
  List<Event>   futureList;
  static int eventId;
  DataSearchSe({ this.listName,this.futureList});
  @override
  String get searchFieldLabel => 'ابحث باسم الحدث';

  @override
  List<Widget> buildActions(BuildContext context) {
    // action for appbar
    return [IconButton(
        tooltip: 'إلغاء البحث',
        icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icon leading
    return IconButton(
        tooltip: "رجوع",
        icon: Icon(Icons.arrow_back ,color: Colors.black,),
        onPressed: () {
          close(context, null);
        });
  }
  Future  fetchSearchedEvent() async {
    Map data={
      'addede_id': eventId.toString(),
    };
    final response = await http
        .post(Uri.parse('${Singleton.apiPath}/getEvent'),body: data);

    if (response.statusCode == 200) {

      var parsed = json.decode(response.body) ;

      return parsed ;
    } else {
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    // result search...

    return  FutureBuilder    (
      future: fetchSearchedEvent(),
      builder: (  context ,  AsyncSnapshot  snapshot){
        if(snapshot.hasData){
          print(snapshot.data);

          return ListView.builder(
              itemCount:1,
              itemBuilder: (context , index) {
                return Column(
                  children: [
                    ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventView(eventID: eventId,)),
                          );
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventView(eventID: eventId,)),
                                  );
                                },
                              ),
                              IconButton(
                                  tooltip: 'حذف الحدث',
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    return customAlertForButton(
                                        snapshot
                                            .data[index].addede_id,
                                        snapshot,
                                        index,
                                        context);
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
                          style:
                          TextStyle(color: Color(0xFF666666)),
                        )),
                    Divider(
                      color: Colors.grey,
                    )
                  ],

                );
              }
          );

        }
        return Center(child: CircularProgressIndicator(),);


      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    //show when someone searchers for something...
    var searchList = query.isEmpty?listName :
    listName.where(( element) => element.startsWith(query )).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder (
          itemCount: searchList.length,
          itemBuilder: (context, index) {
            return ListTile(
              //leading: Image.network('${imgLinks}'),
              leading: Icon(Icons.event_note_rounded),
              title: Text("${searchList[index] }"),
              onTap: () {
                eventId = futureList[index].addede_id ;
                showResults(context);
              },
            );
          }),
    );
  }
  customAlertForButton(
      int addede_id, AsyncSnapshot snapshot, int index, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            child: _EventsMenuState().customAlert(addede_id, snapshot, index, context),
            textDirection: TextDirection.rtl,
          );
        });
  }



}
