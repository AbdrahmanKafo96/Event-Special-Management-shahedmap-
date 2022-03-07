
// CategoryClass  Because the name of a Category  affects one of the libraries
// during import library

class CategoryClass{
    int   category_id;
    String category_name;
    int emergency_phone;

  CategoryClass({
      this.category_id,
      this.category_name,
      this.emergency_phone,
  });

  factory CategoryClass.fromJson(Map<String, dynamic> json) {
    return CategoryClass(
      category_id: json['category_id'],
      category_name: json['category_name'],
      emergency_phone: json['emergency_phone'],
    );
  }
}

class Respo{
  String type_name;
  int notification_id;
  int seen;

  Respo({

    this.type_name,
    this.notification_id,
    this.seen,

  });

  factory Respo.fromJson(Map<String, dynamic> json) {
    return Respo(

      type_name: json['type_name'],
      notification_id: json['notification_id'],
      seen: json['seen'],
    );
  }

}
class EventType {
  //Category category = Category();
    int type_id;
    String type_name;
    int  category_id;
  EventType({
    this.category_id,
    this.type_id,
    this.type_name,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      category_id: json['category_id'],
      type_id: json['type_id'],
      type_name: json['type_name'],
    );
  }
}