import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:shahed/theme/colors_app.dart';

Widget customHoverButton(BuildContext context, {VoidCallback? onPressed, String? text ,IconData? icon}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.75,
    child: HoverButton(
      onpressed: onPressed!,

      splashColor: Color(SharedColor.orangeIntColor),
      hoverTextColor: Color(SharedColor.orangeIntColor),
      highlightColor: Color(SharedColor.orangeIntColor),
      color: Color(SharedColor.deepOrangeColor),
      child:   Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: 3, right: 2, left: 2),
              child: Icon(
                icon,
                color: Theme.of(context)
                    .iconTheme
                    .color,
              ),
            ),
            Text(
              text!,
              style: Theme.of(context)
                  .textTheme
                  .headline4,
            ),
          ]),
    ),
  );
}
