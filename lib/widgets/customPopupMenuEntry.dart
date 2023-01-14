import 'package:flutter/material.dart';
import '../shared_data/shareddata.dart';

  customPopupMenuEntry(BuildContext context,{String? low , medium , high , best}){

  return <PopupMenuEntry<int>>[
    PopupMenuItem<int>(
      value: 0,
      child: Text(low!=null ?low :SharedData.getGlobalLang().normalDefault(),style:  Theme.of(context).textTheme.bodyText1),
    ),
    PopupMenuItem<int>(
      value: 1,
      child: Text(medium!=null ?medium :SharedData.getGlobalLang().hybrid(),style: Theme.of(context).textTheme.bodyText1),
    ),
    PopupMenuItem<int>(
      value: 2,
      child: Text( high!=null ?high :SharedData.getGlobalLang().satellite(),style: Theme.of(context).textTheme.bodyText1),
    ),
    PopupMenuItem<int>(
      value: 3,
      child: Text(best!=null ?best :SharedData.getGlobalLang().terrain() ,style: Theme.of(context).textTheme.bodyText1),
    ),
  ];
}