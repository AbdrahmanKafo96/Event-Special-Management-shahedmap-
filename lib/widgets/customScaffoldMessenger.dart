import 'package:flutter/material.dart';

customScaffoldMessenger({String? text, BuildContext? context, Color? color,int seconds=2}){
  return ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(
     text!,
     style: Theme.of(context).textTheme.bodyText1,
     textAlign: TextAlign.center,
    ),
    duration:  Duration(seconds: seconds,),
    backgroundColor: color,
  ));
}