import 'package:shahed/provider/language.dart';
import 'package:shahed/singleton/singleton.dart';

class ValidatorClass {
  static Language language = SharedClass.getLanguage();

  static bool isValidEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    return emailValid;
  }

  static String? isValidName(String value) {
    if (value.isEmpty || value == null) {
      return language.thisFieldIsRequired();
    } else {
      if (value.length <= 14 && value.length >= 3) {
        if (RegExp(r'^[A-Za-zء-ي]+(?:[ _-][A-Za-zء-ي]+)*$').hasMatch(value))
          return null;
        else {
          return language.nameMustBeCorrectly();
        }
      } else
        return language.nameMustBeCorrectly();
    }
  }

  static String isValidPassword(String password) {
    String isValid = "";
        // upperCaseChars = "(.*[A-Z].*)",
        // lowerCaseChars = "(.*[a-z].*)",
        // numbers = "(.*[0-9].*)",
        // specialChars = "(.*[@,#,\$,%,].*\$)";

    if (password == null || password.isEmpty)
      isValid = language.thisFieldIsRequired();
    else if (password.length > 24 || password.length < 6)
      isValid =  language.passwordContainLessThan24Error();
    // else if (!RegExp(upperCaseChars).hasMatch(password))
    //   isValid = language.passwordContainCapitalLetterError();
    // else if (!RegExp(lowerCaseChars).hasMatch(password))
    //   isValid = language.passwordContainLowercaseLetterError();
    // else if (!RegExp(numbers).hasMatch(password))
    //   isValid = language.passwordContainAtLeastOneNumberError();
    // else if (!RegExp(specialChars).hasMatch(password))
    //   isValid = language.passwordContainAtLeastSpecialCharacterError();
    else
      isValid = "";
    return isValid;
  }
}
