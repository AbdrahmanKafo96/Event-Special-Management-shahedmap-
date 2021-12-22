
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

    Future<bool> checkInternetConnectivity(BuildContext context) async {
      bool stateConn=true;
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        // _showDialog(
        //     'لا يوجد اتصال بالإنترنت',
        //     "من فضلك اتصل بالانترنت لتسجيل في التطبيق",context
        // );
        Scaffold.of(context).showSnackBar(SnackBar(
          content:
              Text(
                'اتصل بالانترنت من فضلك',
                textDirection: TextDirection.rtl,
              ),


          backgroundColor: Colors.orangeAccent,
        ));
        return stateConn=false ;
      }
      return stateConn;
    }

    // void closeKeyBoard(BuildContext context) {
    //   FocusScopeNode currentFocus = FocusScope.of(context);
    //   if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    //     FocusManager.instance.primaryFocus.unfocus();
    //   }
    // }