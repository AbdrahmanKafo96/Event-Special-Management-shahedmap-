import 'package:flutter/material.dart';
import 'dart:ui' as ui;
Widget customAppBar(
    {String title="",
    Color backgroundColor,
    double elevation = 0.0,
    double titleSpacing = 1.0,
    Widget flexibleSpace,
    Widget leading,
    List<Widget> actions,
      IconData icon}) {

    return AppBar(
      titleSpacing: titleSpacing,
     actions: actions,
      leading: leading,
      flexibleSpace:  Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  //Color.fromRGBO(36, 36, 36, 0.85),
                  Color(0xFF424242),
                  Color(0xff212121),
                ],
              )),
            ) ,
      title: Text.rich(
        TextSpan(
          children:  [
            TextSpan(text:" $title "),

            WidgetSpan(

                alignment: ui.PlaceholderAlignment.middle,
                child: Icon(icon, color: Colors.white )),
          //  TextSpan(text: 'downloads on both stores'),
          ],
        ),

        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: elevation,
      //leading: IconButton(icon: iconButton, onPressed: () {}),
      backgroundColor: backgroundColor,
    );

}
