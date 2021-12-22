import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:systemevents/model/Category.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  CategoryClass categoryClass = CategoryClass();
  EventType eventType = EventType();
  String _eventName;
  String _eventDate;

  //int _eventType;
  double _lat;
  double _lng;
  String _description;
  File _imageFile, _videoFile;
  List<XFile>  _xfile  , _listSelected;

  get getListSelected => _listSelected;

  set setListSelected(List<XFile> value) {
    _listSelected = value;
  }

  final String event_name;

  final addede_id;
  LatLng tappedPoint  =null ;

  Event({this.event_name, this.addede_id});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      event_name: json['event_name'],
      addede_id: json['addede_id'],
    );
  }

  get getVideoFile => _videoFile;

  set setVideoFile(value) {
    _videoFile = value;
  }

  List<XFile> get getXFile => _xfile;

  set setXFile(List<XFile>  value) {
    _xfile=value;
  }
  void dropValue(int index){
    if(index>-1)
      _xfile.removeAt(index);
  }

  // File get getImageFile => _imageFile;
  //
  // set setImageFile(File value) {
  //   _imageFile = value;
  // }

  String get getEventName => _eventName;

  set setEventName(String value) {
    _eventName = value;
  }

  String get getEventDate => _eventDate;

  set setEventDate(String value) {
    _eventDate = value;
  }

  double get getLat => _lat;

  set setLat(double value) {
    _lat = value;
  }

  double get getLng => _lng;

  set setLng(double value) {
    _lng = value;
  }

  String get getDescription => _description;

  set setDescription(String value) {
    _description = value;
  }
}
