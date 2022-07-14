import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:doctor_app/res/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class updateProfile extends StatefulWidget {
  @override
  _updateProfileState createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool ismale = true;
  bool isself = true;
  bool confirmPass = true;
  bool pass = true;
  bool oldPass = true;
  String recordDate;
  TextEditingController _nameController;
  TextEditingController _oldPasswordController;
  TextEditingController _passwordController;
  TextEditingController _conformPasswordController;

  UserModel _userModel;
  bool loading = true;
  String errorMessage;
  bool isTextEditable = true;

  File imageFile;
  double _progressValue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _conformPasswordController = TextEditingController();
    getUserData();
    defaultUserData();
  }

  defaultUserData() async {
    _userModel = await UserModel().getUserModel();
    _nameController.text = (_userModel?.name ?? "");
    // _nameController.text = (_userModel?.name ?? "") + " " + (_userModel?.fName ?? "");
    recordDate = _userModel.birthday;
    ismale = _userModel.gender == 1;
    setState(() {});
  }

  getUserData() async {
    String userTempId = await UserModel.getUserId;
    int userId = int.parse(userTempId);
    // String userId = await UserModel.getUserId;

    Map body = {'user_id': userId.toString()};
    var response = await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey)
        .post(url: MY_PROFILE_URL, body: body);
    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getUserData);
      return;
    }

    if (response is Response) {
      if (response.data is Map) {
        _userModel = UserModel.fromJson(response.data['patient_profile']);

        _userModel.savePrefs();
        _nameController.text = (_userModel?.name ?? "");
        // _nameController.text = (_userModel?.name ?? "") + " " + (_userModel?.fName ?? "");
        recordDate = _userModel.birthday;
        ismale = _userModel.gender == 1;
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          hight: size1.longestSide * 0.15666178,
          paddingBottom: size.convert(context, 15),
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          //trailingIcon: _trailing(),
          centerWigets: _logo(),
          leadingIcon: _leadingIcon(),
        ),
      ),
      body: _body(),
      //drawer: openDrawer(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: size.convert(context, 16),
            ),
            _bookingInfo(),
            SizedBox(
              height: size.convert(context, 18),
            ),
            Center(
              child: ErrorMessage(
                message: errorMessage,
              ),
            ),
            _button(),
            SizedBox(
              height: size.convert(context, 18),
            ),
          ],
        ),
      ),
    );
  }

  _bookingInfo() {
    return Container(
      color: portionColor.withOpacity(0.05),
      margin: EdgeInsets.symmetric(horizontal: size.convertWidth(context, 24)),
      //color: portionColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: size.convertWidth(context, 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (isTextEditable) {
                    _settingModalBottomSheet();
                  }
                },
                child: Container(
                  child: circularImage(
                    file: imageFile,
                    imageUrl: _userModel?.pic == null || _userModel?.pic == ""
                        ? "assets/icons/Group_1849.png"
                        : USER_IMAGE_URL + _userModel.pic,
                    h: size.convert(context, 80),
                    w: size.convert(context, 80),
                    assetImage: _userModel?.pic == null || _userModel?.pic == "" ? true : false,
                    fileImage: imageFile != null,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              TranslationBase.of(context).namehints,
              style: TextStyle(
                color: portionColor,
                fontFamily: "Latoregular",
                fontSize: size.convert(context, 12),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
          Container(
            child: CustomTextField(
              isEnable: isTextEditable,
              hints: TranslationBase.of(context).namehints,
              borderwidth: 1,
              textEditingController: _nameController,
            ),
          ),
          SizedBox(
            height: size.convert(context, 14),
          ),
          Container(
            child: Text(
              TranslationBase.of(context).dateOfBirth,
              style: TextStyle(
                color: portionColor,
                fontFamily: "Latoregular",
                fontSize: size.convert(context, 12),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
          GestureDetector(
            onTap: () {
              if (isTextEditable) {
                _datePickerLocalized();
              }
            },
            child: Container(
                height: size.convert(context, 50),
                width: size.convertWidth(context, 360),
                //margin: EdgeInsets.symmetric(horizontal: size.convertWidth(context, 10)),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: buttonColor,
                  width: size.convert(context, 1),
                )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: size.convert(context, 15),
                    ),
                    RichText(
                      text: TextSpan(
                          text: recordDate ?? TranslationBase.of(context).dateOfBirthhints,
                          style: TextStyle(
                            fontSize: size.convert(context, 12),
                            fontFamily: "LatoRegular",
                            color: portionColor,
                          )),
                    ),
                  ],
                )),
          ),
//          Container(
//            child: CustomTextField(
//              hints: TranslationBase.of(context).dateOfBirthhints,
//              borderwidth: 1,
//              textEditingController: _dateOfBirthController,
//            ),
//          ),
          SizedBox(
            height: size.convert(context, 14),
          ),
          Container(
            child: Text(
              TranslationBase.of(context).gender,
              style: TextStyle(
                color: portionColor,
                fontFamily: "Latoregular",
                fontSize: size.convert(context, 12),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
          _swapbutton(
              "gender", TranslationBase.of(context).male, TranslationBase.of(context).female),
          SizedBox(
            height: size.convert(context, 20),
          ),

          Container(
            child: Text(
              TranslationBase.of(context).oldPassword,
              style: TextStyle(
                color: portionColor,
                fontFamily: "Latoregular",
                fontSize: size.convert(context, 12),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
          Container(
            child: CustomTextField(
              isEnable: isTextEditable,
              obscureText: oldPass,
              hints: TranslationBase.of(context).passwordhints,
              borderwidth: 1,
              textEditingController: _oldPasswordController,
              trailingIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    oldPass = !oldPass;
                  });
                },
                child: Container(
                  child: oldPass
                      ? Icon(
                          IcoFontIcons.eyeBlocked,
                          color: buttonColor,
                          size: size.convert(context, 25),
                        )
                      : Icon(
                          IcoFontIcons.eye,
                          color: buttonColor,
                          size: size.convert(context, 25),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),

          Container(
            child: Text(
              TranslationBase.of(context).accountPassword,
              style: TextStyle(
                color: portionColor,
                fontFamily: "Latoregular",
                fontSize: size.convert(context, 12),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
          Container(
            child: CustomTextField(
              isEnable: isTextEditable,
              obscureText: pass,
              hints: TranslationBase.of(context).passwordhints,
              borderwidth: 1,
              textEditingController: _passwordController,
              trailingIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    pass = !pass;
                  });
                },
                child: Container(
                  child: pass
                      ? Icon(
                          IcoFontIcons.eyeBlocked,
                          color: buttonColor,
                          size: size.convert(context, 25),
                        )
                      : Icon(
                          IcoFontIcons.eye,
                          color: buttonColor,
                          size: size.convert(context, 25),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),

          Container(
            child: Text(
              TranslationBase.of(context).repasswordhints,
              style: TextStyle(
                color: portionColor,
                fontFamily: "Latoregular",
                fontSize: size.convert(context, 12),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
          Container(
            child: CustomTextField(
              isEnable: isTextEditable,
              hints: TranslationBase.of(context).enterPasswordAgain,
              textEditingController: _conformPasswordController,
              obscureText: confirmPass,
              borderwidth: 1,
              trailingIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    confirmPass = !confirmPass;
                  });
                },
                child: Container(
                  child: confirmPass
                      ? Icon(
                          IcoFontIcons.eyeBlocked,
                          color: buttonColor,
                          size: size.convert(context, 25),
                        )
                      : Icon(
                          IcoFontIcons.eye,
                          color: buttonColor,
                          size: size.convert(context, 25),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.convert(context, 8),
          ),
        ],
      ),
    );
  }

  _swapbutton(String ch, String index1, String index2) {
    if (ch == "gender") {
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  print("press on ${index1}");
                  if (isTextEditable) {
                    setState(() {
                      ismale = true;
                    });
                  }
                },
                child: Container(
                  width: size.convertWidth(context, 180),
                  height: size.convert(context, 41),
                  decoration: BoxDecoration(
                    border: ismale
                        ? null
                        : Border(
                            top: BorderSide(
                              color: buttonColor,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: buttonColor,
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: buttonColor,
                              width: 1,
                            ),
                          ),
                    color: ismale ? buttonColor : portionColor.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Text(
                      index1,
                      style: TextStyle(
                          color: ismale ? Colors.white : portionColor,
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoRegular"),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  print("press on ${index2}");
                  if (isTextEditable) {
                    setState(() {
                      ismale = false;
                    });
                  }
                },
                child: Container(
                  width: size.convertWidth(context, 181),
                  height: size.convert(context, 41),
                  decoration: BoxDecoration(
                      border: !ismale
                          ? null
                          : Border.all(
                              color: buttonColor,
                              width: 1,
                            ),
                      color: !ismale ? buttonColor : portionColor.withOpacity(0.05)),
                  child: Center(
                    child: Text(
                      index2,
                      style: TextStyle(
                          color: !ismale ? Colors.white : portionColor,
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoRegular"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  print("press on ${index1}");
                  if (isTextEditable) {
                    setState(() {
                      isself = true;
                    });
                  }
                },
                child: Container(
                  width: size.convertWidth(context, 180),
                  height: size.convert(context, 41),
                  decoration: BoxDecoration(
                    border: isself
                        ? null
                        : Border(
                            top: BorderSide(
                              color: buttonColor,
                              width: 1,
                            ),
                            left: BorderSide(
                              color: buttonColor,
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: buttonColor,
                              width: 1,
                            ),
                          ),
                    color: isself ? buttonColor : portionColor.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Text(
                      index1,
                      style: TextStyle(
                          color: isself ? Colors.white : portionColor,
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoRegular"),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  print("press on ${index2}");
                  if (isTextEditable) {
                    setState(() {
                      isself = false;
                    });
                  }
                },
                child: Container(
                  width: size.convertWidth(context, 181),
                  height: size.convert(context, 41),
                  decoration: BoxDecoration(
                      border: !isself
                          ? null
                          : Border.all(
                              color: buttonColor,
                              width: 1,
                            ),
                      color: !isself ? buttonColor : portionColor.withOpacity(0.05)),
                  child: Center(
                    child: Text(
                      index2,
                      style: TextStyle(
                          color: !isself ? Colors.white : portionColor,
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoRegular"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  _button() {
    return Container(
      child: loading
          ? Center(
              child: CircularPercentIndicator(
                backgroundColor: Colors.transparent,
                progressColor: buttonColor,
                percent: _progressValue?.toDouble() ?? 0.0,
                radius: size.convert(context, 40),
                center: Center(
                  child: Text(
                    "${(_progressValue * 100).toInt()} ",
                    style: TextStyle(fontSize: size.convert(context, 16), color: buttonColor),
                  ),
                ),
                lineWidth: size.convert(context, 3),
                animation: false,
                animationDuration: 100,
              ),
            )
          : GestureDetector(
              onTap: loading ? null : _validateForm,
              child: Container(
                height: size.convert(context, 40),
                margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.convert(context, 5)),
                    color: loading ? buttonColor.withOpacity(0.5) : buttonColor),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: TranslationBase.of(context).updateProfile,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.convert(context, 12),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: " ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.convert(context, 12),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _logo() {
    return Container(
      child: Text(
        TranslationBase.of(context).myProfile,
        style: TextStyle(
          fontSize: size.convert(context, 14),
          fontFamily: "LatoRegular",
          color: appBarIconColor,
        ),
      ),
    );
  }

  _leadingIcon() {
    return Container(
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop();
        },
        child: Icon(
          IcoFontIcons.longArrowLeft,
          color: appBarIconColor,
          size: size.convert(context, 25),
        ),
      ),
    );
  }

  void _validateForm() async {
    setState(() {
      errorMessage = null;
    });

    if (_nameController.text.length < 3) {
      setState(() {
        errorMessage = TranslationBase.of(context).invalidUserName;
      });
      return;
    }
    if (recordDate == null || recordDate == "") {
      setState(() {
        errorMessage = TranslationBase.of(context).dateOfBirth;
      });
      return;
    }

    if (_passwordController.text.length != 0) {
      if (_passwordController.text.length < 6) {
        setState(() {
          errorMessage = TranslationBase.of(context).passwordShort;
        });
        return;
      } else if (_passwordController.text != _conformPasswordController.text) {
        setState(() {
          errorMessage = TranslationBase.of(context).invalidConfirmPassword;
        });
        return;
      }
    }

    _updateProfileServer();
  }

  _updateProfileServer() async {
    setState(() {
      loading = true;
      isTextEditable = false;
    });
    String tempUserId1 = await UserModel.getUserId;
    int userId = int.parse(tempUserId1);
    // String userId = await UserModel.getUserId;
    // print("user_id = ${userId}");
    // print("name = ${_nameController.text}");
    // print("birthday = ${recordDate}");

    FormData body = FormData.fromMap({
      'user_id': userId.toString(),
      'name': _nameController.text,
      'birthday': recordDate,
      'gender': ismale ? '1' : '0'
//      ,
//      'password': _passwordController.text.length != 0
//          ? _passwordController.text
//          : _userModel.password
    });

    if (imageFile != null) {
      body.files.add(
          MapEntry('photo', MultipartFile.fromFileSync(imageFile.path, filename: imageFile.path)));
      print("image path = ${imageFile.path}");
    }
    if (imageFile == null) {
//      body.files.add(MapEntry("photo":_userModel.pic));
    }

    if (_passwordController.text.length != 0) {
      body.fields.add(MapEntry('new_password', _passwordController.text));
      body.fields.add(MapEntry('old_password', _oldPasswordController.text));
    }
    print(body.files.toString());

    var response = await API(
            scaffold: _scaffoldkey,
            context: context,
            uploadProgressCallback: (value) {
              setState(() {
                _progressValue = value;
              });
            },
            showSnackbarForError: false)
        .post(url: UPDATE_PATIENT_PROFILE_URL, body: body);
    setState(() {
      loading = false;
      isTextEditable = true;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context);
      return;
    }

    if (response is String) {
      setState(() {
        print("//////////////////////////////");
        print(response);
        print("//////////////////////////////");
        if (response == "updated failed") {
          errorMessage = "Please edit record";
        } else {
          errorMessage = response;
        }
      });
    }

    if (response is Response) {
      if (response.statusCode >= 200 && response.statusCode <= 204) {
        CustomSnackBar.SnackBar_3Success(_scaffoldkey,
            leadingIcon: Icons.check, title: TranslationBase.of(context).profileUpdatedSuccess);
        getUserData();
        Future.delayed(Duration(seconds: 2)).then((val) {
          Navigator.pushReplacement(
              context, PageTransition(type: PageTransitionType.fade, child: HomePage()));
        });
      }
    }
    setState(() {
      isTextEditable = true;
    });
  }

  _settingModalBottomSheet() {
    print("Bottom sheet");
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: size.convert(context, 22), vertical: size.convert(context, 16)),
            height: size.convert(context, 110),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        TranslationBase.of(context).addARecord,
                        style: TextStyle(
                            fontSize: size.convert(context, 10),
                            fontFamily: "LatoRegular",
                            color: portionColor),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Take a Photo");
                    _onImageButtonPressed(ImageSource.camera);
                    getIt<GlobalSingleton>().navigationKey.currentState.pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: size.convert(context, 10)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            "assets/icons/image.svg",
                            color: buttonColor,
                            height: size.convert(context, 15),
                            width: size.convert(context, 14),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: size.convert(context, 12),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              TranslationBase.of(context).takeAPhoto,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Upload from gallery");
                    getIt<GlobalSingleton>().navigationKey.currentState.pop();
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: size.convert(context, 10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            "assets/icons/file-alt.svg",
                            color: buttonColor,
                            height: size.convert(context, 15),
                            width: size.convert(context, 14),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: size.convert(context, 12),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              TranslationBase.of(context).uploadFromGallery,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _onImageButtonPressed(ImageSource sourceFile) async {
    print("Some thing happen");
    try {
      var imageFile1 = await ImagePicker.pickImage(source: sourceFile);
      setState(() {
        imageFile = imageFile1;
      });
    } catch (e) {
      print("Error " + e.toString());
    }
  }

  _datePickerLocalized() {
    return DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          TranslationBase.of(context).done,
        ),
        cancel: Text(
          TranslationBase.of(context).cancel,
        ),
      ),
      minDateTime: DateTime.utc(1940),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime.utc(DateTime.now().year - 16, 1, 31),
      dateFormat: false ? "dd-MMMM-yyyy" : "yyyy-MMMM-dd",
      locale: TranslationBase.of(context).selectLanguage == "en"
          ? DateTimePickerLocale.en_us
          : TranslationBase.of(context).selectLanguage == "ar"
              ? DateTimePickerLocale.per
              : DateTimePickerLocale.pas,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dt, List<int> index) {
        if (!mounted) return;
//        setState(() {
//          dateTime = dt;
//        });
      },
      onConfirm: (dt, List<int> index) {
        _datePick(dt);
      },
    );
  }

  _datePick(DateTime newdate) {
    setState(() {
      recordDate = newdate.toString().substring(0, 10);
    });
  }
}
