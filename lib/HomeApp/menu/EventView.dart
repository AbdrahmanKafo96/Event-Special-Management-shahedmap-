import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/HomeApp/EventFolder/PickEventImage.dart';
import 'package:systemevents/HomeApp/EventFolder/VideoPicker.dart';
import 'package:systemevents/HomeApp/HomePage.dart';

import 'package:systemevents/provider/EventProvider.dart';
import 'package:systemevents/singleton/singleton.dart';

class EventView extends StatefulWidget {
  int eventID;

  EventView({this.eventID});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  var _response;
  String video = "none";
  List<String> imgList = List.filled(4, null);
  int count;

  final eventNameController = TextEditingController();
  final eventDescController = TextEditingController();

  @override
  initState() {
    super.initState();
    setDataInView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
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
                        iconSize: 24, onPressed: ()  async {
                      SharedPreferences prefs = await Singleton.getPrefInstace();
                      Map userData = Map();
                      userData = {
                        'user_id':prefs.getInt('user_id').toString(),
                        'addede_id': widget.eventID,
                        'description':
                        eventDescController.text.toString(),
                        'event_name':
                         eventNameController.text.toString()

                      };

                      bool result =
                          await Provider.of<EventProvider>(context, listen: false)
                          .updateEvent(userData );
                      if (result) {
                        showShortToast('تمت  عملية التحديث بنجاح', Colors.green);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (Route<dynamic> route) => false,
                        );
                      } else {
                        showShortToast(
                            'حدثت مشكلة تحقق من اتصالك بالانترنت', Colors.red);
                      }
                    }, tooltip: 'حفظ التعديل',
                        icon: Icon(Icons.edit))),
              ],
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.5),
                child: IconButton(
                  tooltip: 'رجوع',
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Provider.of<EventProvider>(context, listen: false).event.nullAll() ;

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
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Stack(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                                  height:
                                      MediaQuery.of(context).size.width * 0.75,
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  child: Card(
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        count>0?
                                        MyCustomImage(
                                            count: count, updateList: imgList)
                                            :MyCustomImage(),
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
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        //  height: 250,
                        height: MediaQuery.of(context).size.height * 0.3,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ListTile(
                              title: Text(
                                'اسم الحدث',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: Icon(Icons.title),
                              trailing: IconButton(
                                tooltip: "تعديل اسم الحدث",
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  createDialog(context, 'تعديل اسم الحدث')
                                      .then((value) {
                                    eventNameController.text = value;
                                  });
                                },
                              ),
                              subtitle: Text(eventNameController.text),
                            ),
                            ListTile(
                              title: Text(
                                'الوصف',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: Icon(Icons.description),
                              trailing: IconButton(
                                tooltip: "تعديل الوصف",
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  createDialog(context, 'تعديل الوصف')
                                      .then((value) {
                                    eventDescController.text = value;
                                  });
                                },
                              ),
                              subtitle: Text(eventDescController.text),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
      ),
    );
  }

  Future<String> createDialog(BuildContext context, String value) {
    TextEditingController textEditingController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              content: TextField(
                decoration: InputDecoration(hintText: 'ادخل نص جديد'),
                controller: textEditingController,
              ),
              actions: [
                MaterialButton(
                    color: Colors.green,
                    child: Text("تعديل"),
                    onPressed: () {
                      Navigator.of(context).pop(textEditingController.text);
                    })
              ],
            ),
          );
        });
  }

  Future<void> setDataInView() async {
    await Provider.of<EventProvider>(context, listen: false)
        .fetchEventDataByEventId(widget.eventID)
        .then((value) {
      setState(() {
        _response = value;
        if (_response != null) {
          count = _response['count'];
          print("the count is $count");
          if (_response['data']['video'] != null)
            video = "http://192.168.1.3:8000" + _response['data']['video'];

          eventNameController.text = _response['data']['event_name'];
          eventDescController.text = _response['data']['description'];
            int index=0;
          for (int i = 1; i <= 4; i++) {
            if(_response['data']['image$i']!=null)
            {
              imgList[index]="http://192.168.1.3:8000" +_response['data']['image$i'];

            } index++;
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
