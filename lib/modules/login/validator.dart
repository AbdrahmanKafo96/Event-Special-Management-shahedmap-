

class ValidatorClass {

  static bool isValidEmail(String email){

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    return emailValid;
  }
  static String isValidName(String value){
    if(value.isEmpty || value==null){
      return "هذا الحقل مطلوب";
    }
    else{
      if(value.length<=14 && value.length>=3)
      {
        if( RegExp(r'^[A-Za-zء-ي]+(?:[ _-][A-Za-zء-ي]+)*$').hasMatch(value))
          return null;
        else{
          return "يجب ادخال الاسم بشكل صحيح";
        }
      }
      else return 'يجب ادخال الاسم بشكل صحيح';
    }
  }

  static String isValidPassword(String password) {
    String isValid = "",
        upperCaseChars = "(.*[A-Z].*)",
        lowerCaseChars = "(.*[a-z].*)",
        numbers = "(.*[0-9].*)",
        specialChars = "(.*[@,#,\$,%,].*\$)";

    if(password ==null || password.isEmpty)
      isValid="هذا الحقل مطلوب";
    else if (password.length > 24 || password.length < 6)
      isValid ="يجب أن يكون طول كلمة المرور أقل من 24 وأكثر من 6 خانات ";
    else if (!RegExp(upperCaseChars).hasMatch(password))
      isValid = "يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل";
    else if (!RegExp(lowerCaseChars).hasMatch(password))
      isValid = "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل";
    else if (!RegExp(numbers).hasMatch(password))
      isValid = "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل";
    else if (!RegExp(specialChars).hasMatch(password))
      isValid = "يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل مثال:@";
    else
      isValid = "";
    return isValid;
  }
}