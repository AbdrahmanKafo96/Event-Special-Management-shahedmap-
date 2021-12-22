import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/HomePage/menu/EventView.dart';
import 'package:systemevents/model/Event.dart';
import 'package:systemevents/provider/EventProvider.dart';
import 'package:systemevents/singleton/singleton.dart';

class EventsMenu extends StatefulWidget {
  @override
  _EventsMenuState createState() => _EventsMenuState();
}

class _EventsMenuState extends State<EventsMenu> {
  Future<List<Event>> futureList;


  @override
  initState() {
    super.initState();
    Singleton.getPrefInstace().then((value) {
      setState(() {
        //  value.getInt('user_id')
        futureList = Provider.of<EventProvider>(context, listen: false)
            .fetchAllListByUserId(value.getInt('user_id'));
      });
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
        future: futureList,
        builder: (context, snapshot) {
          // if(!snapshot.hasData){
          //   return Center(child: CircularProgressIndicator());
          // }

          // if ( snapshot.data==null)
          //   return Center(child: Text('قم بإنشاء حدث جديد'));
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('غير متصل بالانترنت');

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
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              print(
                                                  "the edit id is ${snapshot.data[index].addede_id}");
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
                  : Center(child: Text('قم بإنشاء حدث جديد'));
            default:
              {
                return Center(child: Text('قم بإنشاء حدث جديد'));
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
    return Container(
      child: generateItemsList(),
    );
  }
}
