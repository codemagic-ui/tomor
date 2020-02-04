import 'dart:convert';

class UserModel {
  var customerId;
  var strCustomerProfileImageUrl = "";
  var strCustomerFirstName;
  var strCustomerLastName;
  var strCustomerEmail;
  var strCustomerPhone ;
  var strCustomerUserName = "";
  var strDateOfBirth;
  var strImageUrl;

  var strUserRegistrationType;

  var strUserRegistrationTypeName = "";

  UserModel(
      {this.customerId,
      this.strCustomerProfileImageUrl,
      this.strCustomerFirstName,
      this.strCustomerLastName,
      this.strCustomerEmail,
      this.strCustomerPhone});

  UserModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      customerId = map['id'];
    }

    if (checkForNull("first_name", map)) {
      strCustomerFirstName = map['first_name'];
    }
    if (checkForNull("last_name", map)) {
      strCustomerLastName = map['last_name'];
    }
    if (checkForNull("email", map)) {
      strCustomerEmail = map['email'];
    }
    if (checkForNull("date_of_birth", map)) {
      strDateOfBirth = map['date_of_birth'];
    }
    if (checkForNull("avatar_url", map)) {
      strImageUrl = map['avatar_url'];
      print("Here Your Image : "+strImageUrl);
    }
    if (checkForNull("Phone_number", map)) {
      strCustomerPhone = map['Phone_number'];
    }
  }

  static String addUserInfo(
      emailId,
      password,
      firstName,
      lastName,
      phoneNumber,
      gender,
      dateOfBirth,
      companyName,
     /*streetAddress,
      streetAddress2,
      zipCode,
      city,
      countryId,
      stateId,
      fex,*/
      value) {
    Map<String, dynamic> map = {
      'userName': emailId.toString(),
      'emailId': emailId.toString(),
      'password': password.toString(),
      'firstName': firstName.toString(),
      'lastName': lastName.toString(),
      'phoneNumber': phoneNumber.toString(),
      'gender': gender.toString(),
      'dateOfBirth': dateOfBirth.toString(),
      'companyName': companyName.toString(),
      'newsLetter': value.toString()
    };
    return json.encode(map);
  }

  UserModel.userForLoginFromMap(Map<String, dynamic> map) {
    customerId = map['Id'];
    strCustomerEmail = map['Email'];
    strCustomerUserName = map['Username'];
  }

  static String contactUs(String mEnquiry, String email, String mName) {
    Map<String, dynamic> map = {
      'Email': email,
      'Enquiry': mEnquiry,
      'Subject': "",
      'FullName': mName,
    };
    return json.encode(map);
  }

  static String updateUserInfo(String userName,String gender,String firstName,
      String lastName,String dateOfBirth,String email,String companyName,String fileString,String phoneNumber,String customerId) {
    Map<String, dynamic> map = {
      'Username': userName,
      'Gender': gender,
      'FirstName': firstName,
      'LastName': lastName,
      'DateOfBirth': dateOfBirth,
      'Email': email,
      'CompanyName': companyName,
      'fileString': fileString,
      'phoneNumber': phoneNumber,
      'customerId': customerId,
    };
    return json.encode(map);
  }

  static String searchApiPara(
      String mSearchKeyWord,
      String mCategoryId,
      bool iscClick,
      String midClick,
      String vendorId,
      String minPrice,
      String maxPrice,
      bool sidClick,
      bool avdClick,
      bool asvClick,
      String orderBy,
      String page,
      String customerId,
      String pageSize) {
    Map<String, dynamic> map = {
      'q': mSearchKeyWord.toString(),
      'cid': mCategoryId.toString(),
      'isc': iscClick.toString(),
      'mid': midClick.toString(),
      'vid': vendorId.toString(),
      'pf': minPrice.toString(),
      'pt': maxPrice.toString(),
      'sid': sidClick.toString(),
      'adv': avdClick.toString(),
      'asv': asvClick.toString(),
      'OrderBy': orderBy.toString(),
      'Page': page.toString(),
      'customerId': customerId.toString(),
      'PageSize': pageSize.toString(),
    };
    return json.encode(map);
  }

  UserModel.userForRegistrationFromMap(Map<String, dynamic> map) {
    if (checkForNull("UserRegistrationType", map)) {
      strUserRegistrationType = map['UserRegistrationType'];
    }

    if (checkForNull("UserRegistrationTypeName", map)) {
      strUserRegistrationTypeName = map['UserRegistrationTypeName'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
