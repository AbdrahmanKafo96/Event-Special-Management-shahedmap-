
class MarkerModel{
 final String?  type_name , icon;
 final double? lat, lng;
 //final send_date;
 //final type_id;
 final int? postede_id;

 MarkerModel({this.type_name, this.icon, this.lat, this.lng, this.postede_id});


 factory MarkerModel.fromJson(Map<String, dynamic> json) {
  return MarkerModel(
   type_name: json['type_name'],
   icon: json['icon'],
   lat: double.parse(json['lat']),
   lng: double.parse(json['lng']),
   postede_id: int.parse(json['postede_id']),

  );
 }
}