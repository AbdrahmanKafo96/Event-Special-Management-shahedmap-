import 'dart:io';

class User{
    String? _email;
    String? _password;
    String? _confPassword;
    String? _first_name;
    String? _father_name;
    String? _family_name;
    String? _country;
    String?  _date_of_birth;
    String? api_token;
    int? user_id;
    File?  profilePicture;
  String get getConfPassword => _confPassword??'';

  set setConfPassword(String value) {
    _confPassword = value;
  }

  String get getEmail => _email??'';
  set setEmail(String? value) {
    _email = value!;

  }

  String get getFirstName => _first_name??'';

  set setFirstName(String value) {
    _first_name = value;
  }

  String get getPassword => _password??'';

  set setPassword(String value) {
    _password = value;

  }

  String get getFatherName => _father_name??'';

  set setFatherName(String value) {
    _father_name = value;
  }

  String get getFamilyName => _family_name??'';

  set setFamilyName(String value) {
    _family_name = value;
  }

  String get getCountry => _country??'';

  set setCountry(String value) {
    _country = value;
  }

  String get getDate_of_birth => _date_of_birth??'';

  set setDate_of_birth(String value) {
    _date_of_birth = value;
  }


}

