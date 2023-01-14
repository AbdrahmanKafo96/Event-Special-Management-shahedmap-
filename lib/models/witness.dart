class Witness {
  int? user_id;
  String? first_name, father_name, family_name, date_of_birth, country, image;

  Witness(
      {this.user_id,
      this.first_name,
      this.father_name,
      this.family_name,
      this.country,
      this.date_of_birth,
      this.image});

  factory Witness.fromJson(Map<String, dynamic> json) {
    return Witness(
      user_id: json['user_id'],
      first_name: json['first_name'],
      father_name: json['father_name'],
      family_name: json['family_name'],
      country: json['country'],
      date_of_birth: json['date_of_birth'],
      image: json['image'],
    );
  }
}
