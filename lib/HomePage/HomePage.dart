import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:systemevents/webBrowser/webView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/HomePage/EventFolder/EventSectionOne.dart';
import 'package:systemevents/HomePage/menu/EventView.dart';
import 'package:systemevents/model/Event.dart';
import 'package:systemevents/provider/Auth.dart';
import 'package:systemevents/provider/EventProvider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'menu/EventMenu.dart';
import 'settings/setting.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //State class
  int _activePage = 0;
  final List<Widget> _tabItems = [
    EventsMenu(),
     WebView(),
    Settings(),
  ];
   List<Event>   futureList=[];
   List<dynamic>   listNames=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }
  //GlobalKey _bottomNavigationKey = GlobalKey();
  @override

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation,
        floatingActionButton: _activePage == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventSectionOne()),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black45,
                  size: 24,
                ),
                backgroundColor: Colors.white,
              )
            : null,

        appBar: AppBar(
          leading: _activePage == 0
              ? IconButton(
                  icon: Icon(
                    Icons.logout,
                  ),
                  onPressed: () {
                    Provider.of<UserAuthProvider>(context, listen: false)
                        .logout(context);
                  })
              : SizedBox.shrink(),
          actions: [
            _activePage == 0
                ? IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                        showSearch(context: context,
                            delegate: DataSearchSe(listName: listNames,futureList: futureList));
                    })
                : SizedBox.shrink(),
          ],
          centerTitle: true,
          elevation: 1.0,
          titleSpacing: 1.0,
          title: Text(
            _activePage == 0 ? "الاحداث"  :_activePage == 1?"تطبيق الويب": "الاعدادت",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          //  key: _bottomNavigationKey,
          items: <Widget>[
            //  Icon(Icons.add,),
            Icon(
              Icons.list,
              color: Colors.white,
            ),
            Icon(
              Icons.language,
              color: Colors.white,
            ),
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ],
          backgroundColor: Colors.white,
          buttonBackgroundColor: Color(0xFF2d6335),
          color: Color(0xFF5a8f62),
          onTap: (index) {
            setState(() {
              _activePage = index;
            });
          },
        ),
        body: _tabItems[_activePage],
      ),
    );
  }

  Future getData()   {
    var  list;
     Singleton.getPrefInstace().then((value) async {
        list =    await Provider.of<EventProvider>(context, listen: false)
            .searchByName(value.getInt('user_id')); 
      for(int i=0 ;i <list.length; i ++)
      {
        listNames.add(list[i]['event_name']);
        futureList.add(Event(addede_id:list[i]['addede_id'] , event_name:list[i]['event_name'] )); 
      } 
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
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icon leading
    return IconButton(
        icon: Icon(Icons.arrow_back ,color: Colors.black,),
        onPressed: () {
          close(context, null);
        });
  }
  Future  fetchSearchedEvent(   ) async {
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
                              icon: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                // print(
                                //     "the edit id is ${snapshot.data[index].addede_id}");
                              },
                            ),
                            IconButton(
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
            child: _HomePageState().customAlert(addede_id, snapshot, index, context),
            textDirection: TextDirection.rtl,
          );
        });
  }



}
