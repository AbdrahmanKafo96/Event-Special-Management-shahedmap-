import 'package:flutter/material.dart';
import 'package:systemevents/modules/home/home.dart';
import 'package:systemevents/widgets/custom_app_bar.dart';

class SuccessPage extends StatefulWidget {
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: customAppBar(
        context,
        title: 'نجاح العملية',
        leading:IconButton(
          icon: Icon(Icons.cancel),
          tooltip: 'تخطئ',
          onPressed: (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          color: Color(0xFFf7f7f7),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


               Image.asset(
                  "assets/images/success.gif",
                 // height: MediaQuery.of(context).size.height/2,
                  width:  MediaQuery.of(context).size.width,
                ),

              Text("تم إرسال الحدث بنجاح",style: Theme.of(context).textTheme.headline4,)
            ],
          ),
        )
      ),
    );
  }
}
