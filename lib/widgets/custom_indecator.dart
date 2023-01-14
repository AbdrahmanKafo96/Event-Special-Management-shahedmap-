import 'package:flutter/material.dart';

Widget customCircularProgressIndicator({Color? color}){
  return Container(
      child: Center(
          child: CircularProgressIndicator(
            color: color==null ?Colors.orange :color,
          )));
}