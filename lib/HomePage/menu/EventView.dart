import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:systemevents/HomePage/EventFolder/PickEventImage.dart';
import 'package:systemevents/HomePage/EventFolder/VideoPicker.dart';
import 'package:systemevents/model/Event.dart';
import 'package:systemevents/provider/EventProvider.dart';

class EventView extends StatefulWidget {
  int eventID;

  EventView({this.eventID});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  var _response;
  String video = "none";
  List<String> imgList = [];
  int count;

  final eventNameController = TextEditingController();
  final eventDescController = TextEditingController();

  @override
  initState() {
    super.initState();
    callMe();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'تعديل الحدث',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.5),
                  child: IconButton(
                      iconSize: 24, onPressed: () {

                  }, icon: Icon(Icons.edit))),
            ],
            leading: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.5),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          body: _response == null
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                )
              : Stack(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      //color: Colors.red,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListView(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   border: Border.all(
                                //       color: Colors.blueGrey,// set border color
                                //       width: 2.0),   // set border width
                                //   borderRadius: BorderRadius.all(
                                //       Radius.circular(10.0)), // set rounded corner radius
                                // ),

                                child: TextFormField(
                                  controller: eventNameController,
                                  onChanged: (value) {
                                    Provider.of<EventProvider>(context,
                                            listen: false)
                                        .event
                                        .setEventName = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'ادخل اسم الحدث',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                // decoration: BoxDecoration(
                                //   color: Colors.white,
                                //   border: Border.all(
                                //       color: Colors.blueGrey,// set border color
                                //       width: 2.0),   // set border width
                                //   borderRadius: BorderRadius.all(
                                //       Radius.circular(10.0)), // set rounded corner radius
                                // ),
                                child: TextFormField(
                                  controller: eventDescController,
                                  onChanged: (value) {
                                    Provider.of<EventProvider>(context,
                                            listen: false)
                                        .event
                                        .setDescription = value;
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  maxLength: 500,
                                  decoration: InputDecoration(
                                    hintText: ' ادخل الوصف ',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                            shrinkWrap: true,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Color(0xFF5a8f62),
                        boxShadow: [BoxShadow(blurRadius: 1.0)],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      left: 15,
                      //     bottom: MediaQuery.of(context).size.height * 0.10,
                      child: Center(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.green.withOpacity(0.5),
                                  blurRadius: 7.0,
                                  offset: Offset(0.0, 0.50))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                          ),
                          height: MediaQuery.of(context).size.width * 0.75,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Card(
                            elevation: 0,
                            child: Column(
                              children: [
                                MyCustomImage(
                                    count: count, updateList: imgList),
                                _response['data']['video'] != null
                                    ? VideoPicker(oldVideo: video)
                                    : VideoPicker(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }

  Future<void> callMe() async {
    await Provider.of<EventProvider>(context, listen: false)
        .fetchEventDataByEventId(widget.eventID)
        .then((value) {
      setState(() {
        _response = value;
        if (_response != null) {
          count = _response['count'];
          if (_response['data']['video'] != null)
            video = "http://192.168.1.3:8000" + _response['data']['video'];

          eventNameController.text = _response['data']['event_name'];
          eventDescController.text = _response['data']['description'];

          for (int i = 1; i <= count; i++) {
            imgList
                .add("http://192.168.1.3:8000" + _response['data']['image$i']);
          }
        }
      });
    });
  }
}

// Expanded(
// flex: 2,
// child: Container(
// ),
// ),
