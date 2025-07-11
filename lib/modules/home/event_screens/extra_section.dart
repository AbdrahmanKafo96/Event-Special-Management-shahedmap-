import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:shahed/modules/home/event_screens/SuccessPage.dart';
import 'package:shahed/modules/home/event_screens/event_screen.dart';
import 'package:shahed/modules/home/event_screens/video_picker.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/checkInternet.dart';
import 'package:shahed/widgets/custom_app_bar.dart';
import 'package:shahed/widgets/custom_indecator.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:intl/intl.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/singleton/singleton.dart';

import '../../../theme/colors_app.dart';
import '../../../widgets/customDirectionality.dart';

class EventSectionTow extends StatefulWidget {
  @override
  _EventSectionTowState createState() => _EventSectionTowState();
}

class _EventSectionTowState extends State<EventSectionTow> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child:   customDirectionality(
        child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: customAppBar(
                context,
                title: SharedData.getGlobalLang().newEvent(),
                leading: IconButton(
                  tooltip: SharedData.getGlobalLang().close(),
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Provider.of<EventProvider>(context, listen: false)
                        .event
                        .dropAll();
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Container(
                margin: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 10),
                // padding:
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(SharedColor.darkIntColor),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: SharedColor.black12.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      children: [
                        Text(
                          SharedData.getGlobalLang().addDescription(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              height: double.infinity * 0.3,
                              decoration: BoxDecoration(
                                color: Color(SharedColor.greyIntColor),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24)),
                              ),
                              child: EventForm()),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: VideoPicker()),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: HoverButton(
                            height: 50,
                            splashColor: Color(SharedColor.orangeIntColor),
                            hoverTextColor: Color(SharedColor.orangeIntColor),
                            highlightColor: Color(SharedColor.orangeIntColor),
                            color: Color(SharedColor.deepOrangeColor),
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customCircularProgressIndicator(
                                        color: SharedColor.white,
                                      ),
                                      const SizedBox(
                                        height: 24,
                                        width: 12,
                                      ),
                                      Text(
                                      SharedData.getGlobalLang().waitMessage(),
                                        style:
                                            Theme.of(context).textTheme.headline4,
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.floppyDisk,
                                        color: Theme.of(context).iconTheme.color,
                                      ),
                                      const SizedBox(
                                        height: 24,
                                        width: 12,
                                      ),
                                      Text(
                                        SharedData.getGlobalLang().sendEvent(),
                                        style:
                                            Theme.of(context).textTheme.headline4,
                                      )
                                    ],
                                  ),
                            onpressed: () async {
                              //if (isLoading) return;

                              checkInternetConnectivity(context)
                                  .then((bool value) async {
                                if (value) {

                                //  await Future.delayed(Duration(seconds: 3 ),);
                                  if (Provider.of<EventProvider>(context,
                                                  listen: false)
                                              .event
                                              .getDescription !=
                                          "" &&
                                      Provider.of<EventProvider>(context,
                                                  listen: false)
                                              .event
                                              .getDescription !=
                                          null) {
                                    setState(() => isLoading = true);
                                    Box box = await SharedClass.getBox();
                                    Map userData = Map();
                                    userData = {
                                      'description': Provider.of<EventProvider>(
                                              context,
                                              listen: false)
                                          .event
                                          .getDescription,
                                      'event_name': Provider.of<EventProvider>(
                                              context,
                                              listen: false)
                                          .event
                                          .eventType
                                          .type_name
                                          .toString(),
                                      'sender_id': box.get('user_id').toString(),
                                      'senddate': DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                          .toString(),
                                      'eventtype': Provider.of<EventProvider>(
                                              context,
                                              listen: false)
                                          .event
                                          .eventType
                                          .type_id
                                          .toString(),
                                      'lat': Provider.of<EventProvider>(context,
                                              listen: false)
                                          .event
                                          .getLat
                                          .toString(),
                                      'lng': Provider.of<EventProvider>(context,
                                              listen: false)
                                          .event
                                          .getLng
                                          .toString(),
                                    };

                                    bool? result = await Provider.of<EventProvider>(
                                            context,
                                            listen: false)
                                        .addEvent(userData);
                                    setState(() => isLoading = false);
                                    if (result!) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SuccessPage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    } else {}
                                  } else {
                                    showShortToast(
                                        SharedData.getGlobalLang().descRequired(), SharedColor.red);
                                  }
                                }
                              });
                              setState(() => isLoading = false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
        ),
      ),
    );
  }
}
