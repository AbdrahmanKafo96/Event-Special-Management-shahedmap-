
// CategoryClass  Because the name of a Category  affects one of the libraries
// during import library

class CategoryClass{
    int   category_id;
    String category_name;

  CategoryClass({
      this.category_id,
      this.category_name,
  });

  factory CategoryClass.fromJson(Map<String, dynamic> json) {
    return CategoryClass(
      category_id: json['category_id'],
      category_name: json['category_name'],
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