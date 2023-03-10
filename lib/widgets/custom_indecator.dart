import 'package:flutter/material.dart';
import 'package:shahed/theme/colors_app.dart';

Widget customCircularProgressIndicator({Color? color}){
  return Container(
      child: Center(
          child: CircularProgressIndicator(
            color: color==null ?SharedColor.orange :color,
          )));
}