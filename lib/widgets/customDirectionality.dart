import 'package:flutter/material.dart';
import 'package:shahed/main.dart';
import 'package:shahed/shared_data/shareddata.dart';

Widget customDirectionality( {Widget? child}){

  return Directionality(
    textDirection:  language=="AR"? TextDirection.rtl :TextDirection.ltr,
    child:child!,
  );
}