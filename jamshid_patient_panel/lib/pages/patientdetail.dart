import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/family/family_profile_list.dart';
import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/model/server_body_model/appointment.dart';
import 'package:doctor_app/model/user_model.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'bookingInfo.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter/cupertino.dart';

class patientDetail extends StatefulWidget {
  final CreateAppointment appointment;
  final int clinicId;
  // final String clinicId;
  final String clinicAdress;
  const patientDetail({Key key, this.appointment, this.clinicId, this.clinicAdress})
      : super(key: key);

  @override
  _patientDetailState createState() => _patientDetailState();
}

class _patientDetailState extends State<patientDetail> {
  //static final GlobalKey<FormFieldState<String>> _searchFormKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool isself = true;
  bool isSelfAndDetailsAreNull = false;

  String errorMessage;

  FamilyListModel _familyListModel;
  UserModel userModel;

  //TextEditingController _controllerage = TextEditingController();
  DateTime _setDate = DateTime.now();
  Duration initialtimer = new Duration();
  int selectitem = 1;

  int patientId;
  // String patientId;
  bool addNew = true;

  FamilyProfileModel newFamilyModel;
  bool checkIfFamilyMemberAddedInCaseUserAddNewProfile = false;

  bool submit = false;
  bool ismale = false;
  bool disableTextFieldNumber = true;
  String relationship;
  String relationshipPost;
  TextEditingController _controllerName;
  TextEditingController _controllerPhoneNumber;
  String dateOfBirth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerPhoneNumber = new TextEditingController();
    _controllerName = new TextEditingController();
    getSelfData();
  }

  getSelfData() async {
    String temp1 = await UserModel.getUserId;
    int userId = int.parse(temp1);

    Map body = {'user_id': userId};
    var response = await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey)
        .post(url: MY_PROFILE_URL, body: body);
    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getSelfData);
      return;
    }

    if (response is Response) {
      if (response.data is Map) {
        userModel = UserModel.fromJson(response.data['patient_profile']);
        getFamilyMembers(response.data);
        userModel.savePrefs();
        _setUserData();
      }
    }
  }

  _setUserData() {
    print("User id ${userModel?.id}");
    disableTextFieldNumber = true;
    ismale = userModel?.gender == 1;
    _controllerName.text = userModel?.name ?? "";
    _controllerPhoneNumber.text = userModel?.phone ?? "";
    dateOfBirth = userModel.birthday;

    isSelfAndDetailsAreNull = userModel?.name == null ||
        userModel?.name == "" ||
        userModel?.birthday == null ||
        userModel?.birthday == "";
    if (mounted) setState(() {});
  }

  _setNewProfileData() {
    ismale = true;
    _controllerName.text = "";
    _controllerPhoneNumber.text = "";
    dateOfBirth = null;
    disableTextFieldNumber = false;
    patientId = -1;
    isSelfAndDetailsAreNull = true;
    if (mounted) setState(() {});
  }

  _setSelectProfile(int familyId) {
    print("****FAMILY $familyId");
    if (_familyListModel.familiesModel
            .firstWhere((family) => family.patientID == familyId, orElse: () => null) ==
        null) {
      return;
    }

    FamilyProfileModel familyModel =
        _familyListModel.familiesModel.firstWhere((family) => family.patientID == familyId);
    ismale = familyModel.gender == 1;
    _controllerPhoneNumber.text = "";
    _controllerPhoneNumber.text = familyModel.pPhoneNo;
    _controllerName.text = familyModel.pName;
    dateOfBirth = null;
    dateOfBirth = familyModel.birthday;
    disableTextFieldNumber = false;
    isSelfAndDetailsAreNull = true;

    if ((otherList.relationShipList(context)).contains(familyModel.pRelation))
      relationship = familyModel.pRelation;
    if (mounted) setState(() {});
  }

  getFamilyMembers(var data) async {
//    String userId = await UserModel.getUserId;
//
//    var response = await API(
//            scaffold: _scaffoldkey,
//            context: context,
//            showSnackbarForError: true)
//        .post(url: VIEW_ALL_FAMILY_MEMBER_URL, body: {'user_id': userId});
//
//    if (response == NO_CONNECTION) {
//      CustomSnackBar.SnackBarInternet(_scaffoldkey, context,
//          btnFun: getFamilyMembers);
//      return;
//    }

    _familyListModel = FamilyListModel.fromJson(data);
    _familyListModel.familiesModel.insert(0,
        FamilyProfileModel(patientID: -1, pName: TranslationBase.of(context).selectFamilyMember));

    if (widget.appointment.appointmentDetailModel != null) {
      if (widget.appointment.appointmentDetailModel.pateintId != 0 &&
          widget.appointment.appointmentDetailModel.pateintId != 0 &&
          widget.appointment.appointmentDetailModel.pateintId != 0) {
        isself = false;
        patientId = widget.appointment.appointmentDetailModel.pateintId;
        _setSelectProfile(patientId);
      }
    } else {
      patientId = -1;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    _controllerName.clear();
//    _controllerage.clear();
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
          leadingIcon: _leading(),
          centerWigets: Text(
            TranslationBase.of(context).enterPatentDetailsPageheader,
            style: TextStyle(
              color: appBarIconColor,
              fontFamily: "LatoRegular",
              fontSize: size.convert(context, 14),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _body(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: size.convert(context, 10)),
              child: _button(),
            ),
          )
        ],
      ),
    );
  }

  _leading() {
    return Container(
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
        },
        child: Container(
          child: SvgPicture.asset(
            "assets/icons/back.svg",
            color: appBarIconColor,
          ),

          //child: Image.asset("assets/icons/backarrow.png"),
        ),
      ),
    );
  }

  _body() {
    return _familyListModel == null
        ? Center(
            child: Loading(),
          )
        : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: size.convert(context, 26)),
                      padding: EdgeInsets.only(top: size.convert(context, 28)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: circularImage(
                              imageUrl: widget?.appointment?.doctor?.doctorPicture == null
                                  ? null
                                  : DOCTOR_IMAGE_URL + widget?.appointment?.doctor?.doctorPicture,
                              w: size.convert(context, 62),
                              h: size.convert(context, 62),
                            ),
                          ),
                          SizedBox(
                            width: size.convert(context, 5),
                          ),
                          Container(
                            //color: Colors.deepOrange,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text:
                                            "${widget.appointment?.doctor?.title ?? ""} ${widget.appointment?.doctor?.doctorName ?? ""}",
                                        style: TextStyle(
                                            color: buttonColor,
                                            fontFamily: "LatoRegular",
                                            fontSize: size.convert(context, 14))),
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: widget?.appointment?.doctor?.expert ?? "",
                                        style: TextStyle(
                                            color: portionColor,
                                            fontFamily: "LatoRegular",
                                            fontSize: size.convert(context, 10))),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
//                                       SvgPicture.asset(
//                                        "assets/icons/mapMark.svg",
//                                        height: size.convert(context, 40),
//                                        width: size.convert(context, 40),
//                                      ),
                                      Image.asset(
                                        "assets/icons/Map_1614.png",
                                        width: size.convert(context, 8),
                                        height: size.convert(context, 12),
                                      ),
                                      SizedBox(
                                        width: size.convert(context, 5),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: widget?.clinicAdress ?? '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "LatoRegular",
                                                fontSize: size.convert(context, 10))),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: (widget?.appointment?.doctor?.doctorFee == 0 ||
                                                widget?.appointment?.doctor?.doctorFee == null)
                                            ? "${TranslationBase.of(context).fee}:  ${TranslationBase.of(context).free}"
                                            : "${TranslationBase.of(context).fee}: ${widget?.appointment?.doctor?.doctorFee ?? ""} ${TranslationBase.of(context).currencySymbol ?? ""}",
                                        // "${TranslationBase.of(context).currencySymbol} ${widget?.appointment?.doctor?.doctorFee ?? ''}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "LatoRegular",
                                            fontSize: size.convert(context, 10))),
                                  ),
                                ),
                                SizedBox(
                                  height: size.convert(context, 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.convert(context, 26)),
                    child: Text(
                      TranslationBase.of(context).dateandTime,
                      style: TextStyle(
                        fontSize: size.convert(context, 10),
                        fontFamily: "LatoRegular",
                        color: portionColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 4),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.convert(context, 26)),
                    child: Text(
                      "${widget.appointment.date} ${widget.appointment.time}",
                      style: TextStyle(
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoBold",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 16),
                  ),
                  _bookingInfo(),
                  SizedBox(
                    height: size.convert(context, 15),
                  ),
                  Center(
                    child: ErrorMessage(
                      message: errorMessage,
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 38),
                  ),
                ],
              ),
            ),
          );
  }

  _bookingInfo() {
    print("disbale $disableTextFieldNumber");
    return Container(
      color: portionColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: size.convertWidth(context, 24)),
      //color: portionColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.convert(context, 8),
          ),
          Container(
            child: _swapbutton("Self", TranslationBase.of(context).filterSelf,
                TranslationBase.of(context).someOneElse),
          ),
          SizedBox(
            height: size.convert(context, 14),
          ),
          !isSelfAndDetailsAreNull
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          isself
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            TranslationBase.of(context).bookingFor,
                                            style: TextStyle(
                                              color: portionColor,
                                              fontFamily: "Latoregular",
                                              fontSize: size.convert(context, 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: size.convert(context, 8),
                                    ),

                                    ///dropdown to select the booking for
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.convert(context, 15)),
                                      height: size.convert(context, 50),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: buttonColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(size.convert(context, 5)),
                                      ),
                                      child: DropdownButton(
                                        style: TextStyle(
                                          fontSize: size.convert(context, 12),
                                          fontFamily: "LatoRegular",
                                          color: portionColor,
                                        ),
                                        isExpanded: true,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        value: patientId,
                                        onChanged: (newValue) {
                                          if (newValue == -1) {
                                            addNew = true;
                                            _setNewProfileData();
                                          } else {
                                            _setSelectProfile(newValue);
                                            addNew = false;
                                          }

                                          setState(() {
                                            patientId = newValue;
                                          });
                                        },
                                        items: _familyListModel.familiesModel.map((family) {
                                          return DropdownMenuItem(
                                            child: new Text(family.pName),
                                            value: family.patientID,
                                          );
                                        }).toList(),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.convert(context, 15)),
                                      height: size.convert(context, 50),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: buttonColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(size.convert(context, 5)),
                                      ),
                                      child: DropdownButton(
                                        style: TextStyle(
                                          fontSize: size.convert(context, 12),
                                          fontFamily: "LatoRegular",
                                          color: portionColor,
                                        ),
//              focusColor: Colors.blue,
                                        isExpanded: true,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        hint: Text(relationship ??
                                            TranslationBase.of(context).relationshiphints),
                                        // Not necessary for Option 1
                                        value: relationship,
                                        onChanged: addNew
                                            ? (newValue) {
                                                setState(() {
                                                  relationship = newValue;
                                                  otherList.relationShipList(context).forEach((f) {
                                                    if (newValue == f["Rname"]) {
                                                      relationshipPost = f["PostKey"];
                                                    }
                                                  });
                                                });
                                              }
                                            : null,
                                        items:
                                            (otherList.relationShipList(context)).map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(location["Rname"]),
                                            value: location["Rname"],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: size.convert(context, 14),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  TranslationBase.of(context).numberhints,
                                  style: TextStyle(
                                    color: portionColor,
                                    fontFamily: "Latoregular",
                                    fontSize: size.convert(context, 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.convert(context, 8),
                          ),
                          Container(
                            child: CustomTextField(
                              hints: "07XXXXXXXX",
                              borderwidth: 1,
                              textInputType: TextInputType.number,
                              textEditingController: _controllerPhoneNumber,
                              isEnable: !disableTextFieldNumber,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.convertWidth(context, 14),
                    ),
                    Row(
                      children: <Widget>[
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
                      ],
                    ),
                    SizedBox(
                      height: size.convert(context, 8),
                    ),
                    Container(
                      child: CustomTextField(
                        hints: TranslationBase.of(context).namehints,
                        borderwidth: 1,
                        textEditingController: _controllerName,
                        isEnable: addNew,
//          textInputType: TextInputType.text,
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
                      onTap: !addNew ? null : _datePickerLocalized,
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
                                    text: dateOfBirth == null || dateOfBirth == ""
                                        ? TranslationBase.of(context).dateOfBirth
                                        : dateOfBirth,
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
                    Text(
                      TranslationBase.of(context).gender,
                      style: TextStyle(
                        color: portionColor,
                        fontFamily: "Latoregular",
                        fontSize: size.convert(context, 12),
                      ),
                    ),
                    SizedBox(
                      height: size.convert(context, 8),
                    ),
                    _swapbutton("gender", TranslationBase.of(context).male,
                        TranslationBase.of(context).female)
                  ],
                ),
        ],
      ),
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
            Expanded(
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    // print("press on ${index1}");
                    setState(() {
                      ismale = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).orientation == Orientation.landscape
                        ? size.convertWidth(context, 188)
                        : size.convertWidth(context, 175),
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
                              right: BorderSide(
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
            ),
            Expanded(
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    // print("press on ${index2}");
                    setState(() {
                      ismale = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).orientation == Orientation.landscape
                        ? size.convertWidth(context, 188)
                        : size.convertWidth(context, 175),
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
            ),
          ],
        ),
      );
    } else {
      return Container(
//        decoration: BoxDecoration(
//          color: portionColor.withOpacity(0.05),
//          border: Border.all(color: appColor,
//          width: 1),
//          borderRadius: BorderRadius.circular(5),
//        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    // print("press on ${index1}");
                    setState(() {
                      isself = true;
                      errorMessage = "";
                    });
                    _setUserData();
                  },
                  child: Container(
                    width: MediaQuery.of(context).orientation == Orientation.landscape
                        ? size.convertWidth(context, 188)
                        : size.convertWidth(context, 175),
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
                              right: BorderSide(
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
            ),
            Expanded(
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    // print("press on ${index2}");
                    setState(() {
                      isself = false;
                      errorMessage = "";
                    });

                    _setNewProfileData();
                  },
                  child: Container(
                    width: MediaQuery.of(context).orientation == Orientation.landscape
                        ? size.convertWidth(context, 188)
                        : size.convertWidth(context, 175),
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
            ),
          ],
        ),
      );
    }
  }

  _button() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
      child: submit
          ? Loading()
          : GestureDetector(
              onTap: submit ? null : _verifyDetails,
              child: Container(
                height: size.convert(context, 40),
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
                              text: TranslationBase.of(context).bookAppointmentbuttontext,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.convert(context, 12),
                                fontFamily: "LatoBold",
                              )),
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: TranslationBase.of(context).noBookingFee,
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
      dateOfBirth = newdate.toString().substring(0, 10);
    });
  }

  _verifyDetails() {
    setState(() {
      errorMessage = "";
    });
    if (checkIfFamilyMemberAddedInCaseUserAddNewProfile) {
      _relationBooking(newFamilyModel);
      return;
    }

    bool validateForm = true;
    if (isself) {
      validateForm = _validateForm();
      if (!validateForm) return;
      _selfBooking();
    } else {
      if (patientId == -1) {
        validateForm = _validateForm();
        if (!validateForm) return;

        _createNewFamilyMember();
      } else
        _relationBooking(
            _familyListModel.familiesModel.firstWhere((family) => family.patientID == patientId));
    }
  }

  _validateForm() {
    if (_controllerPhoneNumber.text.length != 0) if (_controllerPhoneNumber.text.length < 10) {
      setState(() {
        errorMessage = TranslationBase.of(context).invalidNumber;
      });
      return false;
    }
    if (_controllerName.text.length < 3) {
      setState(() {
        errorMessage = TranslationBase.of(context).invalidUserName;
      });
      return false;
    }

    if (isself) if (dateOfBirth == null ||
        dateOfBirth == "" ||
        dateOfBirth == "Enter Date of Birth") {
      setState(() {
        errorMessage = TranslationBase.of(context).dateOfBirth;
      });
      return false;
    }

    return true;
  }

  _createNewFamilyMember() async {
    setState(() {
      submit = true;
    });

    String temp2 = await UserModel.getUserId;
    int userId = int.parse(temp2);

    Map body = {
      'user_id': userId,
      'name': _controllerName.text,
      'relation': relationshipPost,
      'phone': _controllerPhoneNumber.text,
      'birthday': dateOfBirth?.replaceAll('-', '/') ?? "",
      'gender': ismale ? 1 : 0
    };
    var response = await API(showSnackbarForError: false, context: context, scaffold: _scaffoldkey)
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
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: TranslationBase.of(context).familyAddedSuccess);
      checkIfFamilyMemberAddedInCaseUserAddNewProfile = true;
      newFamilyModel = FamilyProfileModel.fromJson(response.data);
      _relationBooking(newFamilyModel);
    }
  }

  _selfBooking() async {
    String temp3 = await UserModel.getUserId;
    int userId = int.parse(temp3);
    Map body = {
      'DocotsID': widget.appointment.doctor.doctorID,
      'user_id': userId,
      'family_member_id': 0,
      'date_of_appointment': widget.appointment.date,
      'time_of_appointment': widget.appointment.time,
      'name': _controllerName.text,
      'age': dateOfBirth?.replaceAll('-', '/') ?? "",
      'gender': ismale ? 1 : 0,
      'relation_ship': '',
      'token': 'self',
      "clinic_id": widget.clinicId
    };

    if (widget.appointment.appointmentDetailModel != null) {
      body.addAll({'appointment_id': widget.appointment.appointmentDetailModel.appID});
    }

    _submitTheBooking(body);
  }

  _relationBooking(FamilyProfileModel family) async {
    String temp4 = await UserModel.getUserId;
    int userId = int.parse(temp4);
    Map body = {
      'DocotsID': widget.appointment.doctor.doctorID,
      'user_id': userId,
      'family_member_id': family.patientID,
      'date_of_appointment': widget.appointment.date,
      'time_of_appointment': widget.appointment.time,
      'name': family.pName,
      'age': family.birthday,
      'gender': family.gender == 1 ? 1 : 0,
      'relation_ship': family.pRelation,
      'token': 'other',
      "clinic_id": widget.clinicId
    };
    print(body);
    if (widget.appointment.appointmentDetailModel != null) {
      body.addAll({'appointment_id': widget.appointment.appointmentDetailModel.appID});
    }

    _submitTheBooking(body);
  }

  _submitTheBooking(Map body) async {
    print(body);
    setState(() {
      submit = true;
    });
    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: false)
        .post(
            url: widget.appointment.appointmentDetailModel != null
                ? UPDATE_STORE_APPOINTMENT_URL
                : CREATE_STORE_APPOINTMENT_URL,
            body: body);

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
      if (response.data["appointment_status"] == 1 || response.data["appointment_status"] == 1) {
        CustomSnackBar.SnackBar_3Success(_scaffoldkey,
            leadingIcon: Icons.error_outline, title: "${response.data["message"]}");
        await Future.delayed(
            Duration(
              seconds: 2,
            ), () {
          getIt<GlobalSingleton>().navigationKey.currentState.popUntil((route) => route.isFirst);
          getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: bookingInfo(appointment: widget.appointment, patientName: body['name'])));
        });
      } else {
        CustomSnackBar.SnackBar_3Error(_scaffoldkey,
            leadingIcon: Icons.error_outline, title: "${response.data["message"]}");
      }
      print("store appointments");
      print("appointment_status ${response.data["appointment_status"]}");
    }
  }
}
