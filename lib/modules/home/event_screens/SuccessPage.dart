import 'package:flutter/material.dart';
import 'package:shahed/modules/home/mainpage.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/theme/colors_app.dart';
import 'package:shahed/widgets/customDirectionality.dart';
import 'package:shahed/widgets/custom_app_bar.dart';

class SuccessPage extends StatefulWidget {
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return customDirectionality(
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: SharedData.getGlobalLang().operationSuccess(),
          leading: IconButton(
            icon: Icon(Icons.cancel),
            tooltip: SharedData.getGlobalLang().skip(),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        body: Center(
            child: Container(
          color: Color(SharedColor.deepWhiteOrangeColor),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/success.gif",
                // height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                SharedData.getGlobalLang().sentEvenSuccessfully(),
                style: TextStyle(color: SharedColor.grey, fontSize: 18),
              )
            ],
          ),
        )),
      ),
    );
  }
}
