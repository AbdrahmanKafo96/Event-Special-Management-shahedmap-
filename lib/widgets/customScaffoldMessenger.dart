import 'package:flutter/material.dart';

customScaffoldMessenger({String text, BuildContext context, Color color}){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
     text,
     style: Theme.of(context).textTheme.bodyText1,
     textAlign: TextAlign.center,
    ),
    backgroundColor: color,
  ));
}