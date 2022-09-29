import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import '../shared_data/shareddata.dart';

     Future<bool> checkInternetConnectivity(BuildContext context) async {

      bool stateConn=true;
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(
                SharedData.getGlobalLang().connectInternet(),
                textDirection: TextDirection.rtl,
              ),
          backgroundColor: Colors.orangeAccent,
        ));
        return stateConn=false ;
      }
      return stateConn;
    }

