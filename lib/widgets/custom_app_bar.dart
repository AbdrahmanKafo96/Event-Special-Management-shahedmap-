import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:shahed/theme/colors_app.dart';

PreferredSizeWidget customAppBar(BuildContext context,
    {String title = "",
    Color? backgroundColor,
    double elevation = 0.0,
    double titleSpacing = 1.0,
    Widget? flexibleSpace,
    Widget? leading,
    List<Widget>? actions,
    IconData? icon}) {
  return AppBar(
    titleSpacing: titleSpacing,
     actions: actions,
    leading: leading,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        color: Color(SharedColor.darkIntColor),

      ),
    ),
    title: Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
              alignment: ui.PlaceholderAlignment.middle,
              child: Icon(
                icon,
                color: SharedColor.white,
              )),
          //  TextSpan(text: 'downloads on both stores'),
          TextSpan(text: " $title "),
        ],
      ),
      style: Theme.of(context).textTheme.headline3,
    ),
    centerTitle: true,
    elevation: elevation,
    //leading: IconButton(icon: iconButton, onPressed: () {}),
    backgroundColor: backgroundColor,
  );
}
