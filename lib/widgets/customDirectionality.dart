import 'package:flutter/material.dart';
import 'package:shahed/main.dart';
import 'package:shahed/shared_data/shareddata.dart';

Widget customDirectionality( {Widget child}){
  print("lang inside dirc ${SharedData.getGlobalLang().getLanguage}");
  return Directionality(
    textDirection:  language=="AR"? TextDirection.rtl :TextDirection.ltr,
    child:  child,
  );
}