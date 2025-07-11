import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shahed/theme/colors_app.dart';
import 'package:shahed/widgets/customScaffoldMessenger.dart';
import '../shared_data/shareddata.dart';

     Future<bool> checkInternetConnectivity(BuildContext context) async {

      bool stateConn=true;
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {

        customScaffoldMessenger(context: context, text: SharedData.getGlobalLang().connectInternet(),
        color: SharedColor.colorOrangeAccent,);
        return stateConn=false ;
      }
      return stateConn;
    }

