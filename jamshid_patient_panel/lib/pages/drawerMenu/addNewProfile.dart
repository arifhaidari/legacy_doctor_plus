import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/drawerMenu/familyProfile.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:doctor_app/res/string.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:doctor_app/validator/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class addNewProfile extends StatefulWidget {
  String buttonText;
  FamilyProfileModel profileModel;

  //addNewProfile({Key key, this.buttonText}) : super(key: key);
  addNewProfile({Key key, this.buttonText, this.profileModel}) : super(key: key);

  @override
  _addNewProfileState createState() => _addNewProfileState();
}

class _addNewProfileState extends State<addNewProfile> {
  bool ismale = true;
  bool isself = true;
  String relationship;
  String relationshipPost;
  String errorMessage;
  bool isUploading = false;
  String birthday;
  bool relationDropdown = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  bool submit = false;

  File imageFile;

  double _progressValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfUpdateSetValues();
  }

  _checkIfUpdateSetValues() {
    if (widget.profileModel != null) {
      ismale = widget.profileModel.gender == 1;
      relationship = widget.profileModel.pRelation;
      birthday = widget.profileModel.birthday;
      _nameController.text = widget.profileModel.pName;
      _numberController.text = widget.profileModel.pPhoneNo;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          paddingBottom: size.convert(context, 15),
          hight: size1.longestSide * 0.15666178,
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

  _logo() {
    return Container(
      child: Text(
        widget.profileModel != null
            ? TranslationBase.of(context).updateProfile
            : TranslationBase.of(context).addNewProfile,
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
            // submit ? disableBody() : _bookingInfo(),
            SizedBox(
              height: size.convert(context, 15),
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

  _button() {
    return Container(
      child: submit
          ? Center(
              child: CircularPercentIndicator(
                backgroundColor: Colors.transparent,
                progressColor: buttonColor,
                percent: _progressValue?.toDouble() ?? 0.0,
                radius: size.convert(context, 40),
                center: Center(
                  child: Text(
                    "${(_progressValue * 100).toInt()}",
                    style: TextStyle(fontSize: size.convert(context, 16), color: buttonColor),
                  ),
                ),
                lineWidth: size.convert(context, 3),
                animation: false,
                animationDuration: 100,
              ),
            )
          : GestureDetector(
              onTap: submit ? null : _checkButtonClicked,
              child: Container(
                height: size.convert(context, 40),
                margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.convert(context, 5)),
                    color: submit ? buttonColor.withOpacity(0.8) : buttonColor),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: widget.buttonText ?? TranslationBase.of(context).updateProfile,
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
                              text: "",
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

  _bookingInfo() {
    return Container(
      color: portionColor.withOpacity(0.05),
      padding: EdgeInsets.symmetric(horizontal: size.convertWidth(context, 24)),
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
                  // if (!isUploading) {
                  //   _settingModalBottomSheet();
                  // }
                },
                child: Container(
                  child: circularImage(
                    // file: imageFile,
                    imageUrl: widget.profileModel == null
                        ? "assets/icons/maleIcon.png"
                        : (widget.profileModel?.gender == 1
                            ? "assets/icons/maleIcon.png"
                            : "assets/icons/femaleIcon.png"),
                    h: size.convert(context, 80),
                    w: size.convert(context, 80),
                    assetImage: true,
                    // imageUrl:
                    //     widget.profileModel?.pPhoto == null || widget.profileModel?.pPhoto == ""
                    //         ? "assets/icons/Group_1849.png"
                    //         : FAMILY_IMAGE_URL + widget.profileModel?.pPhoto,
                    // h: size.convert(context, 80),
                    // w: size.convert(context, 80),
                    // assetImage:
                    //     widget.profileModel?.pPhoto == null || widget.profileModel?.pPhoto == ""
                    //         ? true
                    //         : false,
                    // fileImage: imageFile != null,
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
              isEnable: !isUploading,
              hints: TranslationBase.of(context).namehints,
              textEditingController: _nameController,
              borderwidth: 1,
            ),
          ),
          SizedBox(
            height: size.convert(context, 14),
          ),
          Container(
            child: Text(
              TranslationBase.of(context).relationshiphints,
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
            padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
            height: size.convert(context, 50),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: buttonColor,
              ),
              borderRadius: BorderRadius.circular(size.convert(context, 5)),
            ),
            child: DropdownButton(
              style: TextStyle(
                fontSize: size.convert(context, 12),
                fontFamily: "LatoRegular",
                color: portionColor,
              ),
//              focusColor: Colors.blue,
              isExpanded: true,
              //underline: Container(),
//              isDense: false,

              icon: Icon(Icons.keyboard_arrow_down),
              hint: Text(relationship ?? TranslationBase.of(context).relationshiphints),
              // Not necessary for Option 1
              value: relationship,
              onChanged: isUploading
                  ? null
                  : (newValue) {
                      setState(() {
                        print(newValue.toString());
                        relationship = newValue;
                        otherList.relationShipList(context).forEach((f) {
                          if (newValue == f["Rname"]) {
                            relationshipPost = f["PostKey"];
                          }
                        });
                        print(relationshipPost);
                      });
                    },

              items: (otherList.relationShipList(context)).map((location) {
                return DropdownMenuItem(
                  child: new Text(location["Rname"] ?? ""),
                  value: location["Rname"],
                );
              }).toList(),
            ),
          ),
//          GestureDetector(
//            onTap: () {
//              setState(() {
//                relationDropdown = !relationDropdown;
//                print(relationDropdown);
//              });
//              //_dropdownMenu();
//            },
//            child: Container(
//              padding:
//                  EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
//              height: size.convert(context, 50),
//              decoration: BoxDecoration(
//                border: Border.all(
//                  width: 1,
//                  color: appColor,
//                ),
//                borderRadius: BorderRadius.circular(size.convert(context, 5)),
//              ),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    relationship,
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontFamily: "LatoRegular",
//                      fontSize: size.convert(context, 12),
//                    ),
//                  ),
//                  Icon(
//                    Icons.keyboard_arrow_down,
//                    color: Colors.black,
//                    size: size.convert(context, 24),
//                  )
//                ],
//              ),
//            ),
//          ),
//          SizedBox(
//            height: size.convert(context, 14),
//          ),
          SizedBox(
            height: size.convert(context, 14),
          ),
          Container(
            child: Text(
              TranslationBase.of(context).number,
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
              isEnable: !isUploading,
              textEditingController: _numberController,
              hints: TranslationBase.of(context).numberHint,
              borderwidth: 1,
              textInputType: TextInputType.number,
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
              if (!isUploading) {
                _datePickerLocalized();
              }

              return;
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
                          text: birthday ?? TranslationBase.of(context).dateOfBirthhints,
                          style: TextStyle(
                            fontSize: size.convert(context, 12),
                            fontFamily: "LatoRegular",
                            color: portionColor,
                          )),
                    ),
                  ],
                )),
          ),
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
            height: size.convert(context, 15),
          ),
        ],
      ),
    );
  }

  disableBody() {
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.convert(context, 25), vertical: size.convert(context, 35)),
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(color: appColor, shape: BoxShape.circle),
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: size.convert(context, 15),
                      )),
                ),
              ],
            ));
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  _swapbutton(String ch, String index1, String index2) {
    if (ch == "gender") {
      return Container(
//        decoration: BoxDecoration(
//          color: portionColor.withOpacity(0.05),
//          border: Border.all(color: appColor,
//          width: 1),
//          borderRadius: BorderRadius.circular(5),
//        ),
        child: Row(
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  // print("press on ${index1}");
                  if (!isUploading) {
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
                  if (!isUploading) {
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
                  if (!isUploading) {
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
                  if (!isUploading) {
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

  _datePick(DateTime newdate) {
    setState(() {
      birthday = newdate.toString().substring(0, 10);
    });
  }

  _checkButtonClicked() {
    setState(() {
      errorMessage = null;
    });

    bool validated = _validateData();

    if (!validated) return;

    if (widget.profileModel == null)
      _createNewFamilyMember();
    else
      _updateFmailyMember();
  }

  _validateData() {
    _progressValue = 0;
//    if (isself) if (birthday == "Enter Date of Birth" ||
//        birthday == "" ||
//        birthday == null) {
//      setState(() {
//        errorMessage = TranslationBase.of(context).dateOfBirth;
//      });
//      return false;
//    }

    if (_nameController.text.length < 3) {
      setState(() {
        errorMessage = TranslationBase.of(context).invalidUserName;
      });
      return false;
    }

    if (_numberController.text.length != 0) if (_numberController.text.length < 10) {
      setState(() {
        errorMessage = TranslationBase.of(context).invalidNumber;
      });
      return false;
    }

    return true;
  }

  _createNewFamilyMember() async {
    setState(() {
      submit = true;
      isUploading = true;
    });
    String tempId = await UserModel.getUserId;
    int userId = int.parse(tempId);
    // String userId = await UserModel.getUserId;
    FormData body = FormData.fromMap({
      'user_id': userId.toString(),
      'name': _nameController.text,
      'relation': relationshipPost,
      'phone': _numberController.text,
      'birthday': birthday ?? "",
      'gender': ismale ? '1' : '0'
    });

    if (imageFile != null) {
      body.files.add(MapEntry('photo', MultipartFile.fromFileSync(imageFile.path)));
    }

    var response = await API(
            scaffold: _scaffoldkey,
            context: context,
            uploadProgressCallback: (value) {
              setState(() {
                _progressValue = value;
              });
            },
            showSnackbarForError: false)
        .post(url: ADD_FAMILY_MEMBER_URL, body: body);
    setState(() {
      submit = false;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        errorMessage = TranslationBase.of(context).internetError;
      });
      return;
    }

    if (response is Response) {
      getIt<GlobalSingleton>().navigationKey.currentState.pop();
    }
    setState(() {
      isUploading = true;
    });
  }

  _updateFmailyMember() async {
    setState(() {
      submit = true;
      isUploading = true;
    });

    FormData body = FormData.fromMap({
      'family_member_id': widget.profileModel.patientID.toString(),
      'name': _nameController.text,
      'relation': relationshipPost,
      'phone': _numberController.text,
      'birthday': birthday ?? "",
      'gender': ismale ? '1' : '0'
    });

    if (imageFile != null) {
      body.files.add(MapEntry('photo', MultipartFile.fromFileSync(imageFile.path)));
    }

    var response = await API(
            scaffold: _scaffoldkey,
            context: context,
            uploadProgressCallback: (value) {
              setState(() {
                _progressValue = value;
              });
            },
            showSnackbarForError: false)
        .post(url: UPDATE_FAMILY_MEMBER_URL, body: body);
    setState(() {
      submit = false;
      isUploading = true;
    });

    if (response == NO_CONNECTION) {
      setState(() {
        errorMessage = TranslationBase.of(context).internetError;
      });
      return;
    }

    if (response is Response) {
      Navigator.of(context).pop();
      // getIt<GlobalSingleton>().navigationKey.currentState.pop();
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => familyProfile()));
      // Navigator.push(
      //     context, PageTransition(type: PageTransitionType.fade, child: familyProfile()));
    }
  }

  // _settingModalBottomSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           height: size.convert(context, 110),
  //           color: Colors.white,
  //           padding: EdgeInsets.symmetric(
  //               horizontal: size.convert(context, 22), vertical: size.convert(context, 16)),
  //           child: Column(
  //             children: <Widget>[
  //               Container(
  //                 child: Row(
  //                   children: <Widget>[
  //                     Text(
  //                       TranslationBase.of(context).addARecord,
  //                       style: TextStyle(
  //                           fontSize: size.convert(context, 10),
  //                           fontFamily: "LatoRegular",
  //                           color: portionColor),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   print("Take a Photo");
  //                   _onImageButtonPressed(ImageSource.camera);
  //                   getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
  //                 },
  //                 child: Container(
  //                   margin: EdgeInsets.only(top: size.convert(context, 10)),
  //                   child: Row(
  //                     children: <Widget>[
  //                       Container(
  //                         child: SvgPicture.asset(
  //                           "assets/icons/image.svg",
  //                           color: buttonColor,
  //                           height: size.convert(context, 15),
  //                           width: size.convert(context, 14),
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: size.convert(context, 12),
  //                       ),
  //                       Expanded(
  //                         child: Container(
  //                           child: Text(
  //                             TranslationBase.of(context).takeAPhoto,
  //                             style: TextStyle(
  //                               color: Colors.black,
  //                               fontFamily: "LatoRegular",
  //                               fontSize: size.convert(context, 12),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   print("Upload from gallery");
  //                   getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
  //                   _onImageButtonPressed(ImageSource.gallery);
  //                 },
  //                 child: Container(
  //                   margin: EdgeInsets.only(
  //                     top: size.convert(context, 10),
  //                   ),
  //                   child: Row(
  //                     children: <Widget>[
  //                       Container(
  //                         child: SvgPicture.asset(
  //                           "assets/icons/file-alt.svg",
  //                           color: buttonColor,
  //                           height: size.convert(context, 15),
  //                           width: size.convert(context, 14),
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: size.convert(context, 12),
  //                       ),
  //                       Expanded(
  //                         child: Container(
  //                           child: Text(
  //                             TranslationBase.of(context).uploadFromGallery,
  //                             style: TextStyle(
  //                               color: Colors.black,
  //                               fontFamily: "LatoRegular",
  //                               fontSize: size.convert(context, 12),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  // _onImageButtonPressed(ImageSource sourceFile) async {
  //   print("Some thing happen");
  //   try {
  //     var imageFile1 = await ImagePicker.pickImage(source: sourceFile);
  //     setState(() {
  //       imageFile = imageFile1;
  //     });
  //   } catch (e) {
  //     print("Error " + e.toString());
  //   }
  // }

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
}
