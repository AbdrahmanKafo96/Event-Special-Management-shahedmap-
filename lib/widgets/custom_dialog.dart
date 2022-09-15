import 'package:flutter/material.dart';
 import 'package:systemevents/modules/home/event_screens/event_category.dart';

Future<String> createDialog(BuildContext context, String value , String btnTitle ,
    dynamic Function( {TextEditingController textEditingController} ) f ,{int num }) {
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
            content:num ==null?TextField(
              decoration: InputDecoration(hintText: 'ادخل نص جديد'),
              controller: textEditingController,
            ): Container(child: EventCategory(),height: 100,),
            actions: [
              MaterialButton(
                  color: Colors.green,
                  child: Text(btnTitle),
                  onPressed: ()=>f(textEditingController: textEditingController),
               //    onPressed: () {
               //      Navigator.of(context).pop(textEditingController.text);
               //    }
            )],
          ),
        );
      });
}
