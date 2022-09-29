import 'package:flutter/material.dart';

import '../shared_data/shareddata.dart';


  customPopupMenuEntry(){

  return <PopupMenuEntry<int>>[
    PopupMenuItem<int>(
      value: 0,
      child: Text(SharedData.getGlobalLang().hybrid(),style: TextStyle(color: Colors.grey),),
    ),
    PopupMenuItem<int>(
      value: 1,
      child: Text(SharedData.getGlobalLang().normal(),style: TextStyle(color: Colors.grey),),
    ),
    PopupMenuItem<int>(
      value: 2,
      child: Text( SharedData.getGlobalLang().satellite(),style: TextStyle(color: Colors.grey),),
    ),
    PopupMenuItem<int>(
      value: 3,
      child: Text(SharedData.getGlobalLang().terrain() ,style: TextStyle(color: Colors.grey),),
    ),
  ];
}