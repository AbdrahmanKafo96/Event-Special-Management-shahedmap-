import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahed/models/event.dart';
import 'package:shahed/modules/home/menu/view_screen.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/shimmer/shimmer.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shahed/widgets/custom_dialog.dart';
import '../../../widgets/customDirectionality.dart';
import 'search.dart';

class EventsMenu extends StatefulWidget {
  @override
  _EventsMenuState createState() => _EventsMenuState();
}

class _EventsMenuState extends State<EventsMenu> {
  Future<List<Event>> fuList;
  List<Event> futureList = [];
  List<dynamic> listNames = [];
  bool result = true;

  @override
  initState() {
    super.initState();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        setState(() {
          result = false;
        });
      } else {
        getData();
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    // await Future.delayed(Duration(milliseconds: 1500));
    // setState(() {
    SharedClass.getBox().then((value) {
      setState(() {
        //  value.getInt('user_id')
        fuList = Provider.of<EventProvider>(context, listen: false)
            .fetchAllListByUserId(value.get('user_id'));
      });
    });
  }

    getData() {
    var list;
    SharedClass.getBox().then((value) async {
      list = await Provider.of<EventProvider>(context, listen: false)
          .searchData(value.get('user_id'));
      try {
        if (list != false)
          for (int i = 0; i < list.length; i++) {
            listNames.add(list[i]['event_name']);
            futureList.add(Event(
                addede_id: int.parse(list[i]['addede_id']),
                event_name: list[i]['event_name'],
                description: list[i]['event_name'] == null
                    ? ""
                    : list[i]['event_name']));
          }
      } catch (e) {}
    });
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
              return snapshot.hasData
                  ? RefreshIndicator(
                      displacement: 5,
                      onRefresh: fetchData,
                      child: ListView.builder(
                        shrinkWrap: true,

                        itemCount: snapshot.data.length,
                        // separatorBuilder: (context, index) => Divider(
                        //   color: Colors.black,
                        // ),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
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
                                    //  tileColor: Color(0xFF424250),
                                    onTap: () {
                                      checkInternetConnectivity(context)
                                          .then((bool value) async {
                                        if (value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EventView(
                                                      eventID: int.parse(
                                                          snapshot.data[index]
                                                              .addede_id),
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
                                                        builder: (context) => EventView(
                                                            eventID: int.parse(
                                                                snapshot
                                                                    .data[index]
                                                                    .addede_id),
                                                            eventName: snapshot
                                                                .data[index]
                                                                .event_name)),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                          IconButton(
                                              tooltip: SharedData.getGlobalLang().deleteEvent(),
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                checkInternetConnectivity(
                                                        context)
                                                    .then((bool value) async {
                                                  if (value) {
                                                    return customDeleteEventAlert(
                                                        int.parse(snapshot
                                                            .data[index]
                                                            .addede_id),
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
                                      color: Colors.grey.shade200,
                                    ),
                                    title: Text(
                                      '${snapshot.data[index].event_name}',
                                      softWrap: true,
                                      //overflow: TextOverflow.visible,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    subtitle: Text(
                                      '${snapshot.data[index].description}',
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,

                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ),
                              ),
                              // Divider(
                              //   color: Colors.grey,
                              // )
                            ],
                          );
                        },
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/emptyimage.png'),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Text(
                              SharedData.getGlobalLang().mustCreateNewEvent(),
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          ],
                        ),
                      ),
                    );
            default:
              {
                return Center(
                    child: Text(SharedData.getGlobalLang().createNewEvent(),
                        style: Theme.of(context).textTheme.subtitle1));
              }
          }

        });
  }

  Future<AlertDialog> customDeleteEventAlert(int addede_id,
      AsyncSnapshot snapshot, int index, BuildContext context) async {
    return await customReusableShowDialog(
      context,
      SharedData.getGlobalLang().deleteEvent(),
      widget: Text(SharedData.getGlobalLang().alertDeleteEvent()),
      actions: <Widget>[
        TextButton(
          child: Text(
            SharedData.getGlobalLang().cancel(),
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: TextButton(
            child: Text(
              SharedData.getGlobalLang().deleteEvent(),
              style: TextStyle(color: Colors.white),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return   customDirectionality(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppBar(context,actions: [
            IconButton(
                color: Colors.red,
                tooltip: SharedData.getGlobalLang().search(),
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
          ], title: SharedData.getGlobalLang().events(), icon: FontAwesomeIcons.list),
          body: result == true
              ? generateItemsList()
              : Container(
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/images/wifi.png'),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ),
                ),
      ),
    );
  }
}
