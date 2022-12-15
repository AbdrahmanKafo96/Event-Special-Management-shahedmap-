import 'package:intl/intl.dart';

class Mission {
  // [{"":"Mission test","mission_date":"2022-10-05 01:12:26","":"32.890839","lng_start":"13.171785","lat_finish":"32.896986","lng_finish":"13.269705","seen":"\u0000"}]
  final String mission_name, mission_date;
  final double lat_start, lng_start, lat_finish, lng_finish;
  final int seen;
  int mission_id;
  List points;

  Mission(
      {this.mission_id,
      this.mission_name,
      this.mission_date,
      this.lat_start,
      this.lng_start,
      this.lat_finish,
      this.lng_finish,
      this.seen ,this.points});

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
        mission_id: int.parse(json['mission_id']),
        mission_name: json['mission_name'],
        mission_date: json['mission_date'].toString(),
        lat_start: double.parse(json['lat_start']),
        lng_start: double.parse(json['lng_start']),
        lat_finish: double.parse(json['lat_finish']),
        lng_finish: double.parse(json['lng_finish']),
        points:  json['mission_path'] ,
        seen: int.parse(json['seen']));
  }
}
