import 'package:i_am_a_student/utils/Constants.dart';

class Validator {

  static Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp regexEmail = new RegExp(emailPattern);

  static Pattern phonePattern = "\\d{10}|(?:\\d{3}-){2}\\d{4}|\\(\\d{3}\\)\\d{3}-?\\d{4}";
  static RegExp regexPhone = new RegExp(emailPattern);

  static validateEmail(String value, String errorTextForEmptyField,
      String errorTextForInvalidField) {
    if (value.isNotEmpty) {
      if (regexEmail.hasMatch(value)) {
        return null;
      } else {
        return errorTextForInvalidField;
      }
    } else {
      return errorTextForEmptyField;
    }
  }

  static validateFormField(String value, String errorTextForEmptyField,
      String errorTextInvalidField, int type) {
    switch (type) {
      case Constants.NORMAL_VALIDATION:
        if (value.isEmpty) {
          return errorTextForEmptyField;
        }
        break;

      case Constants.EMAIL_VALIDATION:
        return validateEmail(value, errorTextForEmptyField, errorTextInvalidField);
        break;

      case Constants.PHONE_VALIDATION:
        if (value.isNotEmpty) {
          if (isNumeric(value) && value.length == 10) {
            return null;
          } else {
            return errorTextInvalidField;
          }
        } else {
          return errorTextForEmptyField;
        }
        break;

      case Constants.STRONG_PASSWORD_VALIDATION:
        if (value.isNotEmpty) {
          if (value.length >= 6) {
            return null;
          } else {
            return errorTextInvalidField;
          }
        } else {
          return errorTextForEmptyField;
        }
        break;

      case Constants.PHONE_OR_EMAIL_VALIDATION:
        if (value.isNotEmpty) {
          if (regexEmail.hasMatch(value)) {
            return null;
          } else if (isNumeric(value)) {
            if(value.length == 10){
              return null;
            }else{
              return errorTextInvalidField;
            }
          } else {
            return errorTextInvalidField;
          }
        } else {
          return errorTextForEmptyField;
        }
        break;
    }
  }

  static bool isNumeric(String str) {
    try{
      var value = double.parse(str);
    } on FormatException {
      return false;
    } finally {
      return true;
    }
  }
}
