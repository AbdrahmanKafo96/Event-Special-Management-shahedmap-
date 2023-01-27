 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/counter_provider.dart';
 import 'package:badges/badges.dart' as badge ;
Widget customCard(IconData icon, String title, Color color,
    BuildContext context, String routName) {
  var provider = Provider.of<CounterProvider>(context);
  return Container(
    child: Card(
      color: Color(0xff33333d),
      // color:  Colors.black12.withOpacity(0.5),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      // color: color,
      borderOnForeground: true,
      elevation: 5,
      shadowColor: Colors.black.withOpacity(.5),
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
                      child:
                              (routName == "Missions" &&
                                  provider.getCounterMissions == true)
                          ? badge.Badge(
                                 badgeContent: Icon(
                                Icons.brightness_1,
                                size: 12,
                                color: Colors.white,
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                              ),
                            )
                          :(routName == "response" &&
                                  provider.getCounterNotification == true)? badge.Badge(
                                badgeContent: Icon(
                                  Icons.brightness_1,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                ),
                              ) :Icon(
                              icon,
                              color: Colors.white,
                            )
                      // child: Image.asset(containerImage,),
                      ),
                  backgroundColor: color,
                  radius: 30,
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "$title",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
