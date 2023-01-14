import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

Widget customHoverButton(BuildContext context, {VoidCallback? onPressed, String? text ,IconData? icon}) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.75,
    child: HoverButton(
      onpressed: onPressed!,

      splashColor: Color(0xFFFF8F00),
      hoverTextColor: Color(0xFFFF8F00),
      highlightColor: Color(0xFFFF8F00),
      color: Color(0xFFfe6e00),
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
