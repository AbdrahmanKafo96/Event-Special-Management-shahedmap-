import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customCard( IconData icon , String title){
  return  Card(
    color: Colors.white,
    borderOnForeground: true,
    elevation:4.0,
    margin: new EdgeInsets.all(8.0),
    child: Container(

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
                    GoogleFonts.notoSansArabic(
                      textStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)
                    )
              ),
            )
          ],
        ),
      ),
    ),
  );
}