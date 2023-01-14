
// CategoryClass  Because the name of a Category  affects one of the libraries
// during import library

import 'package:flutter/material.dart';
import 'package:shahed/models/navigation_item.dart';

class CategoryClass{
    int?   category_id;
    String? category_name;
    int? emergency_phone;

  CategoryClass({
      this.category_id,
      this.category_name,
      this.emergency_phone,
  });

  factory CategoryClass.fromJson(Map<String, dynamic> json) {
    return CategoryClass(
      category_id: int.parse(json['category_id']),
      category_name: json['category_name'],
      emergency_phone: int.parse(json['emergency_phone']),
    );
  }
}

class Respo{
  String? type_name;
  int? notification_id;
  int? seen;

  Respo({

    this.type_name,
    this.notification_id,
    this.seen,

  });

  factory Respo.fromJson(Map<String, dynamic> json) {
    return Respo(

      type_name: json['type_name'],
      notification_id: int.parse(json['notification_id']),
      seen: int.parse(json['seen']),
    );
  }

}
class EventType {
  //Category category = Category();
    int? type_id;
    String? type_name;
    int?  category_id;
  EventType({
    this.category_id,
    this.type_id,
    this.type_name,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      category_id: int.parse(json['category_id']),
      type_id: int.parse(json['type_id']),
      type_name: json['type_name'],
    );
  }
}
class MyList {
  IconData? icon;
  String? title;
  BuildContext? context;
  String? routPage;
  Color? color;
  NavigationItem? item;


  MyList({this.icon, this.title, this.context, this.routPage, this.color , this.item});
}