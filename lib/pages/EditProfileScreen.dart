import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_am_a_student/models/UserModel.dart';
import 'package:i_am_a_student/pages/MyAddress.dart';
import 'package:i_am_a_student/parser/GetEditProfileInfo.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/inputDropDown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/OneTimePasswordScreen.dart';
import 'package:i_am_a_student/pages/PasswordScreen.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:intl/intl.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/utils/Validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController firstNameTextController = new TextEditingController();
  TextEditingController lastNameTextController = new TextEditingController();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController phoneNumberTextController = new TextEditingController();
  TextEditingController birthDateController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  FocusNode firstNameFocusNode = new FocusNode();
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusNode companyFocusNode = new FocusNode();
  FocusNode fifthFocusNode = new FocusNode();

  String verifiedPhoneNumber;
  String verifiedEmail = "";
  String strFirstName = "";
  String strLastName = "";

  File imageFromGallery;
  File newFile;

  bool isError = false;
  bool isInternet;
  bool isLoading;
  UserModel userModel;

  final dateFormat = DateFormat("dd,mm,yyyy");

  DateTime strDate;

  DateTime date = new DateTime.now();

  String dateGet;
  String imageFromDatabase;
  String selectedGender;

  Map resourceData;

  @override
  void initState() {
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && isLoading) {
          callApi();
        } else if (isLoading != null && !isLoading) {
          return layoutMain();
        }
      } else {
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(onPressedRetyButton: () {
        internetConnection();
      });
    }
    return new Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: AppColor.appColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget layoutMain() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? prefix0.TextDirection.rtl
          : prefix0.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.getValueFromKey("nop.EditProfileScreen.title.myAccount", resourceData)),
        ),
        bottomNavigationBar: new Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 0.5, color: Colors.grey.withAlpha(100)))),
            height: 65.0,
            padding: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: RaisedBtn(
                text: Constants.getValueFromKey("Admin.Common.SaveChanges", resourceData).toUpperCase(),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    await updateUserInfo();
                  }
                },
              ),
            )),
        body: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            new Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                imageFromGallery != null
                    ? CircleAvatar(
                        radius: 50, backgroundImage: FileImage(imageFromGallery))
                    : CircleAvatar(
                        radius: 50,
                  backgroundImage: newFile != null ? NetworkImage(imageFromDatabase):AssetImage("images/user.png"),
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatBtn(onPressed: showAddPhotoAlertDialog, text: Constants.getValueFromKey("nop.EditProfileScreen.changePhoto", resourceData)),
              ],
            ),
            editProfile(),
          ],
        ),
      ),
    );
  }

  Widget editProfile() {
    return Form(
      key: formKey,
      child: new Theme(
        data: ThemeData(primaryColor: AppColor.appColor),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new TextFormField(
                      decoration:
                          InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.FirstName", resourceData)),
                      controller: firstNameTextController,
                      focusNode: firstNameFocusNode,
                      validator: (value) {
                        return Validator.validateFormField(
                            value,
                            Constants.getValueFromKey("Account.Fields.FirstName.Required", resourceData),
                            "",
                            Constants.NORMAL_VALIDATION);
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(lastNameFocusNode);
                      },
                    ),
                  ),
                  new SizedBox(width: 8.0),
                  Expanded(
                    child: new TextFormField(
                      decoration:
                          InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.LastName", resourceData)),
                      controller: lastNameTextController,
                      focusNode: lastNameFocusNode,
                      validator: (value) {
                        return Validator.validateFormField(
                            value,
                            Constants.getValueFromKey("Account.Fields.LastName.Required", resourceData),
                            "",
                            Constants.NORMAL_VALIDATION);
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(companyFocusNode);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              gender(),
              new TextFormField(
                focusNode: companyFocusNode,
                controller: companyController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration:
                    new InputDecoration(labelText: Constants.getValueFromKey("Account.Fields.Company", resourceData)),
                validator: (value) {
                  return Validator.validateFormField(value,
                      Constants.getValueFromKey("Account.Fields.Company.Required", resourceData), "", Constants.NORMAL_VALIDATION);
                },
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(emailFocusNode);
                },
              ),
              SizedBox(height: 8.0),
              new InputDropdown(
                labelText: Constants.getValueFromKey("Account.Fields.DateOfBirth", resourceData),
                valueText: birthDateController.text,
                onPressed: () {
                  selectDate();
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: Constants.getValueFromKey("Account.Fields.Email", resourceData),
                    //todo  getvalu from model
                    suffixIcon: varyFyIcon(verifiedEmail, emailTextController)),
                controller: emailTextController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return Validator.validateFormField(
                      value,
                      Constants.getValueFromKey("Account.Fields.Email.Required", resourceData),
                      Constants.getValueFromKey("Admin.Common.WrongEmail", resourceData),
                      Constants.EMAIL_VALIDATION);
                },
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(phoneFocusNode);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              new TextFormField(
                decoration: InputDecoration(
                    labelText: Constants.getValueFromKey("Account.Fields.Phone", resourceData),
                    suffixIcon: varyFyIcon(verifiedPhoneNumber, phoneNumberTextController)),
                controller: phoneNumberTextController,
                keyboardType: TextInputType.phone,
                focusNode: phoneFocusNode,
                validator: (value) {
                  return Validator.validateFormField(value,
                      Constants.getValueFromKey("Admin.Address.Fields.PhoneNumber.Hint", resourceData),
                      null, Constants.PHONE_VALIDATION);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAddress()),
                        );
                      },
                      child: new Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(color: AppColor.black)),
                        height: 45.0,
                        child: Center(
                          child: new Body1Text(text: Constants.getValueFromKey("nop.EditProfileScreen.myAddress", resourceData)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PasswordScreen(
                                      type: Constants.CHANGE_PASSWORD,
                                      appbarTitle: Constants.getValueFromKey("admin.common.change", resourceData),
                                      isFromLoginPage: true,
                                    )));
                      },
                      child: new Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(color: AppColor.black)),
                        height: 45.0,
                        child: Center(
                          child: new Body1Text(text: Constants.getValueFromKey("Account.ChangePassword", resourceData)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: new DateTime(1918),
        lastDate: new DateTime.now());

    if (picked != null) {
      setState(() {
        date = picked;
        String pick = DateFormat('dd-MM-yyyy').format(date);
        birthDateController.text = pick;
      });
    }
  }

  Widget gender() {
    if(selectedGender == null) {
      selectedGender = Constants.getValueFromKey("Account.Fields.Gender.Male", resourceData);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: RadioListTile<String>(
            title: Text(Constants.getValueFromKey("Account.Fields.Gender.Male", resourceData)),
            groupValue: selectedGender,
            value: Constants.getValueFromKey("Account.Fields.Gender.Male", resourceData),
            onChanged: (gender) {
              setState(() {
                selectedGender = gender;
              });
            },
          ),
        ),
        new Expanded(
          child: RadioListTile<String>(
            title: Text(Constants.getValueFromKey("Account.Fields.Gender.Female", resourceData)),
            groupValue: selectedGender,
            value: Constants.getValueFromKey("Account.Fields.Gender.Female", resourceData),
            onChanged: (gender) {
              setState(() {
                selectedGender = gender;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget birthDateError() {
    return new Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 5.0)),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CaptionText(
            text: "Enter Birth Date",
            align: TextAlign.start,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  varyFyIcon(String value, TextEditingController covariant) {
    if (covariant == phoneNumberTextController) {
      if (covariant.text == value.toString() && value.length==10) {
        return new IconButton(
            iconSize: 60.0,
            icon: Image.asset("images/Verified.png", color: Colors.green),
            onPressed: null);
      } else if (Constants.isValidPhone(covariant.text)) {
        return new IconButton(
            iconSize: 50.0,
            icon: Image.asset("images/Verify.png", color: Colors.red),
            onPressed: () {
              if (covariant.text.isNotEmpty) {
                //todo call api and get opt then redirect to otp screen
                navigatePush(
                    new OneTimePasswordScreen(
                      type: Constants.SEND_OTP_FROM_PROFILE,
                      sentAddress: covariant.text,
                      isEmail: false,
                    ),
                    false);
              }
            });
      }
    } else if (covariant == emailTextController) {
      if (covariant.text == value.toString()) {
        return new IconButton(
            iconSize: 60.0,
            icon: Image.asset("images/Verified.png", color: Colors.green),
            onPressed: null);
      } else if (Constants.isValidEmail(covariant.text)) {
        return new IconButton(
            iconSize: 50.0,
            icon: Image.asset("images/Verify.png", color: Colors.red),
            onPressed: () {
              if (covariant.text.isNotEmpty) {
                //todo call api and get opt then redirect to otp screen
                navigatePush(
                    new OneTimePasswordScreen(
                      type: Constants.SEND_OTP_FROM_PROFILE,
                      sentAddress: covariant.text,
                      isEmail: true,
                    ),
                    true);
              }
            });
      }
    }
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 120,maxHeight: 120);
    setState(() {
      imageFromGallery = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 120,maxHeight: 120);
    setState(() {
      imageFromGallery = image;
    });
  }

  callApi() async {
    if (isInternet == null) {
      isInternet = await Constants.isInternetAvailable();
    }

    if (isInternet) {
      phoneNumberTextController.text = verifiedPhoneNumber;
      emailTextController.text = verifiedEmail;
      await getUserInformationList();

      isLoading = false;
      setState(() {});
    }
  }

  Future getUserInformationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoginSkipped = prefs.getBool(Constants.prefIsLoginSkippedKey);
    int userId = prefs.getInt(Constants.prefUserIdKeyInt);
    String jsonData = prefs.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
    if (isLoginSkipped) {
      Map result = await GetEditProfileInfo.callApi(
          "${Config.strBaseURL}customers/" + userId.toString());
      if (result["errorCode"] == "0") {
        userModel = result["value"][0];
        companyController.text = result["value"][1];
        verifiedEmail = userModel.strCustomerEmail;
        verifiedPhoneNumber=userModel.strCustomerPhone;
        birthDateController = userModel.strDateOfBirth;
        strFirstName = userModel.strCustomerFirstName;
        strLastName = userModel.strCustomerLastName;
        emailTextController.text = verifiedEmail;
        phoneNumberTextController.text=verifiedPhoneNumber;
        firstNameTextController.text = strFirstName;
        lastNameTextController.text = strLastName;
      } else {
        isError = true;
      }
      isLoading = false;
    } else {
      Map result = await GetEditProfileInfo.callApi("${Config.strBaseURL}customers/" + userId.toString());
      if (result["errorCode"] == "0") {
        userModel = result["value"][0];
        companyController.text = result["value"][1];
        if(userModel.strImageUrl!=null) {
        imageFromDatabase=userModel.strImageUrl;
          newFile= new File(imageFromDatabase); }
        verifiedEmail = userModel.strCustomerEmail;
        verifiedPhoneNumber=userModel.strCustomerPhone;
        DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
        if(userModel.strDateOfBirth!=null){
        DateTime dateTime = dateFormat.parse(userModel.strDateOfBirth);
        dateGet = new DateFormat("dd-MM-yyyy").format(dateTime);}
        birthDateController.text = dateGet;
        strFirstName = userModel.strCustomerFirstName;
        strLastName = userModel.strCustomerLastName;
        emailTextController.text = verifiedEmail;
        phoneNumberTextController.text=verifiedPhoneNumber;
        firstNameTextController.text = strFirstName;
        lastNameTextController.text = strLastName;
      } else {
        isError = true;
      }
      isLoading = false;
    }
  }

  Future updateUserInfo() async {
    Constants.progressDialog(true, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(Constants.prefUserIdKeyInt);
    String base64Image = "";
    if (imageFromGallery != null && imageFromGallery.toString() != "") {
      List<int> imageBytes = imageFromGallery.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
    }
    if (birthDateController.text != null &&
        birthDateController.text.toString() != "") {
        String strJson = UserModel.updateUserInfo(
          emailTextController.text.toString(),
          selectedGender.toString(),
          firstNameTextController.text.toString(),
          lastNameTextController.text.toString(),
          birthDateController.text.toString(),
          emailTextController.text.toString(),
          companyController.text.toString(),
          base64Image.toString(),
          phoneNumberTextController.text.toString(),
          userId.toString());
      if (userId != null) {
        Map result = await GetEditProfileInfo.callApiForUpdateUser(
            "${Config.strBaseURL}customers/customerinfo", strJson);
        if (result["errorCode"] == "0") {
          Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
          Fluttertoast.showToast(msg: result['value']);
          Navigator.pop(context);
        } else {
          Constants.progressDialog(false, context,Constants.getValueFromKey("nop.ProgressDilog.title", resourceData));
          Fluttertoast.showToast(msg: result['value']);
          isError = true;
        }
      }
    } else {
      Fluttertoast.showToast(msg: Constants.getValueFromKey("Account.Fields.DateOfBirth.Required", resourceData));
    }
  }

  void showAddPhotoAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(Constants.getValueFromKey("nop.EditProfileScreen.addPhoto", resourceData)),
          content: new Container(
            height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    getImageFromCamera();
                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(Constants.getValueFromKey("nop.EditProfileScreen.takePhoto", resourceData),
                        textAlign: TextAlign.start),
                  ),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                InkWell(
                  onTap: () {
                    getImageFromGallery();
                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(Constants.getValueFromKey("nop.EditProfileScreen.choosefromGallery", resourceData),
                        textAlign: TextAlign.start),
                  ),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(Constants.getValueFromKey("Admin.Common.Cancel", resourceData),
                        textAlign: TextAlign.start),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    setState(() {});
  }

  navigatePush(Widget page, bool isEmail) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));

    if (isEmail) {
      setState(() {
        verifiedEmail = emailTextController.text;
      });
    } else {
      setState(() {
        verifiedPhoneNumber = phoneNumberTextController.text;
      });
    }
  }


}
