import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/HomePage/EventFolder/EventSectionTow.dart';
import 'package:systemevents/HomePage/EventFolder/eventForm.dart';
import 'dart:ui' as ui;

import 'package:systemevents/provider/EventProvider.dart';


class EventSectionOne extends StatefulWidget {
  @override
  _EventSectionOneState createState() => _EventSectionOneState();
}

class _EventSectionOneState extends State<EventSectionOne> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'بيانات الحدث',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                 Provider.of<EventProvider>(context, listen: false).event.dropAll();
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            actions: [
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: IconButton(
                    onPressed: () {
                      Navigator
                          .of(context)
                          .pushReplacement( MaterialPageRoute(builder: (BuildContext context) => EventSectionTow() ));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                    )),
              ),
            ],
          ),
          body: Container(
            margin: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 25),
            height: double.infinity,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: EventForm())

                // Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
