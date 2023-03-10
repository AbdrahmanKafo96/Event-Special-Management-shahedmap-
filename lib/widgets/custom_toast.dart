import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/colors_app.dart';

void showShortToast(String meg ,Color color) {
  Fluttertoast.showToast(
      msg: "$meg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: SharedColor.white,
      fontSize: 14.0,

  );
}