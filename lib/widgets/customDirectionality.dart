import 'package:flutter/material.dart';
import 'package:shahed/shared_data/shareddata.dart';

Widget customDirectionality( {Widget child}){
  return Directionality(
    textDirection:  SharedData.getGlobalLang().getLanguage=="AR"? TextDirection.rtl :TextDirection.ltr,
    child:  child,
  );
}