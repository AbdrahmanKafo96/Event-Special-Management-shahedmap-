import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/menu/image_picker.dart';
import 'package:shahed/modules/home/event_screens/video_picker.dart';
import 'package:shahed/modules/home/home.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/singleton/singleton.dart';
import 'package:shahed/widgets/custom_dialog.dart';

import '../../../widgets/customDirectionality.dart';

class EventView extends StatefulWidget {
  int eventID;String eventName;

  EventView({this.eventID , this.eventName});

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
      child:   customDirectionality(
        child: Scaffold(
              appBar: customAppBar(
                context,
                elevation: 1.0,
                title:'${widget.eventName}',
                actions: [
                  IconButton(
                 //   color: Colors.white,
                     // iconSize: 24,
                      onPressed: ()  async {
                  checkInternetConnectivity(context).then((bool value) async {
                    if(value){
                      Box box = await SharedClass.getBox();
                      Map userData = Map();
                      userData = {
                        'user_id':box.get('user_id').toString(),
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
                        showShortToast(SharedData.getGlobalLang().updateSuccessfully(), Colors.green);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                              (Route<dynamic> route) => false,
                        );
                      } else {
                        showShortToast(SharedData.getGlobalLang().updateWasNotSuccessful(), Colors.orange);
                      }
                    }

                  });}, tooltip:SharedData.getGlobalLang().saveUpdates(),
                      icon: Icon(Icons.edit)),
                  IconButton(
                      tooltip: SharedData.getGlobalLang().delete(),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        checkInternetConnectivity(context).then((
                            bool value) async {
                          if (value) {
                            return customReusableShowDialog(
                                 context,
                                     SharedData.getGlobalLang().alertDeleteEvent(),
                                   // widget: Text(" هل انت متأكد من حذف الحدث؟ "),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                         SharedData.getGlobalLang().cancel(),
                                          style: TextStyle(color: Colors.white),
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
                                            int postId = widget.eventID;

                                            SharedClass.getBox().then((
                                                value) async{
                                             await  Provider.of<EventProvider>(
                                                  context, listen: false)
                                                  .deleteEvent(
                                                  postId,
                                                  value.get('user_id'));
                                            });
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                           // Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  );

                          }
                        });
                      })
                ],
                leading: IconButton(
                  tooltip: SharedData.getGlobalLang().back(),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Provider.of<EventProvider>(context, listen: false).event.nullAll() ;
                    Navigator.pop(context);
                  },
                ),
              ),
              body: _response == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 7.0,
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                            child:  _response['data']['video'] != null
                                  ? VideoPicker(oldVideo: video , eventID: widget.eventID)
                                  : VideoPicker(),

                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Card(
                            shadowColor:Color(0xff424250),
                            elevation: 0.5,
                            color: Color(0xff424250),
                            shape:  RoundedRectangleBorder(

                              //  side: BorderSide(color: Colors.gr, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(24),)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(SharedData.getGlobalLang().pickImages() ,style: Theme.of(context).textTheme.headline4,),
                                  Padding(padding: EdgeInsets.only(right: 5,left: 5),
                                    child:Text(SharedData.getGlobalLang().imageMessage() ,style: Theme.of(context).textTheme.subtitle1,),
                                  ),
                                  count>0?
                                  MyCustomImage(
                                      count: count, updateList: imgList , eventID: widget.eventID)
                                      :MyCustomImage(),
                                ],
                              ),
                            ),
                          ),
                        )


                      ],
                    )),
      ),
    );
  }


  Future<void> setDataInView() async {
    await Provider.of<EventProvider>(context, listen: false)
        .fetchEventDataByEventId(widget.eventID)
        .then((value) {
      setState(() {
        _response = value;
        if (_response != null) {
          count = _response['count'];

          if (_response['data']['video'] != null)
            video = "${SharedClass.routePath}" + _response['data']['video'];

          eventNameController.text = _response['data']['event_name'];
          eventDescController.text = _response['data']['description'];
            int index=0;
          for (int i = 1; i <= 4; i++) {
            if(_response['data']['image$i']!=null)
            {
              imgList[index]="${SharedClass.routePath}" +_response['data']['image$i'];
print(imgList[index]);
            } index++;
          }
        }
      });
    });
  }
}