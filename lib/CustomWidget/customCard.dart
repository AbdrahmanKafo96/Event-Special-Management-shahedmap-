import 'package:flutter/material.dart';

Widget customCard( IconData icon , String title){
  return  Card(
    borderOnForeground: true,
    elevation:4.0,
    margin: new EdgeInsets.all(8.0),
    child: Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.8),
      //       spreadRadius: 5,
      //       blurRadius: 5,
      //       offset: Offset(0, 7), // changes position of shadow
      //     ),
      //   ],
      // ),

      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
          //  SizedBox(height: 20.0),
            Center(
                child: Icon(
                  icon,
                  size: 20.0,
                  color: Colors.blueGrey,
                )),
            SizedBox(height: 10.0),
            new Center(
              child: new Text(title,
                  style:
                  new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)
              ),
            )
          ],
        ),
      ),
    ),
  );
}