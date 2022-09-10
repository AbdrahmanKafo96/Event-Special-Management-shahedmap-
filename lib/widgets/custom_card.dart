import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customCard(
    IconData icon, String title, Color color, BuildContext context  ) {
  return Card(
    color:  Colors.black12.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
    ),
    // color: color,
    borderOnForeground: true,
    elevation: 4.0,
    margin: EdgeInsets.all(8.0),
    child: Container(

      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //color: Colors.green,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 5),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: CircleAvatar(
                // backgroundImage: AssetImage(containerImage,),
                child: Container(
                    // width: 31,
                    //  height: 31,
                    child: Icon(
                  icon,
                  color: Colors.white,
                )
                    // child: Image.asset(containerImage,),
                    ),
                backgroundColor: color,
                radius: 30,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "$title",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );

  // return Material(
  //   color: Colors.transparent,
  //   child: InkWell(
  //     onTap: () {},
  //     child: Container(
  //       margin: EdgeInsets.all(15),
  //       padding: EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         color: Colors.grey,
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Container(
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.green,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black12,
  //                   offset: Offset(0, 5),
  //                   blurRadius: 5.0,
  //                 ),
  //               ],
  //             ),
  //             child: CircleAvatar(
  //               // backgroundImage: AssetImage(containerImage,),
  //               child: Container(
  //                 width: 31,
  //                 height: 31,
  //                 child: Icon(
  //                   Icons.ac_unit,
  //                   size: 30,
  //                 ),
  //                 // child: Image.asset(containerImage,),
  //               ),
  //               backgroundColor: Colors.grey,
  //               radius: 25,
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text("containerText",
  //                   style: GoogleFonts.notoSansArabic(
  //                       textStyle: TextStyle(
  //                           fontSize: 18.0,
  //                           color: Colors.red,
  //                           fontWeight: FontWeight.bold))),
  //               Icon(
  //                 Icons.arrow_forward,
  //                 color: Colors.white,
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}
