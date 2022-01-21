import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showShortToast(String meg ,Color color) {
  Fluttertoast.showToast(
      msg: "$meg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}