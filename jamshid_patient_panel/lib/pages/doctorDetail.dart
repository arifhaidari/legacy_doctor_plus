import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/doctor/doctor_detail_model.dart';
import 'package:doctor_app/model/doctor/my_doctor_list_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/selectAppointmentDate.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doctor_app/res/color.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';

class doctorDetail extends StatefulWidget {
  final int doctorId;
  // final String doctorId;

  const doctorDetail({Key key, this.doctorId}) : super(key: key);

  @override
  _doctorDetailState createState() => _doctorDetailState();
}

class _doctorDetailState extends State<doctorDetail> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  double rating = 3;

  //it not be greater than 1
  double rate = 0.634;

  DoctorDetailModel _doctorDetailModel;
  bool educationExpand = false;
  bool specializationExpand = false;
  bool professionalMemebershipExpand = false;

  bool bookmarkProcess = false;
  bool alreadyAddedToFavourite = false;

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// LEFT After first block of doctor information as the api is not providing the data
  /// required once the apis is correct start after first block and there is still data
  /// missing in first block
  ///
  ///

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoctorDetail();
    getMyDoctor();
  }

  getDoctorDetail() async {
    print("doctor id = ${widget.doctorId}");
    var response = await API(context: context, scaffold: _scaffoldkey, showSnackbarForError: true)
        .get(url: DOCTOR_INFO_URL + "${widget.doctorId.toString()}");
    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getDoctorDetail);
      return;
    }
    print('//////////////response vlaue ');
    print(response);

    if (response is Response) {
      if (response.data is Map) _doctorDetailModel = DoctorDetailModel.fromJson(response.data);
      print('////////////////////////================');
      print("this the rating data ::: ${_doctorDetailModel?.ratingModel?.doctorCheckup ?? ""}");
      setState(() {});
    }
  }

  getMyDoctor() async {
    String temp = await UserModel.getUserId;
    int userId = int.parse(temp);
    // print("user_id :${userId}");
    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(url: MY_DOCTOR_URL, body: {'user_id': userId});

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getMyDoctor);
      return;
    }

    if (response is Response) {
      MyDoctorModelList myDoctorModelList = MyDoctorModelList.fromJson(response.data);

      alreadyAddedToFavourite = myDoctorModelList.myDoctors
              .firstWhere((doctor) => doctor.doctorID == widget.doctorId, orElse: () => null) !=
          null;

      if (mounted) setState(() {});
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
            leadingIcon: _leading(),
            trailingIcon: _trailing(),
            centerWigets: _center(),
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
        ));
  }

  _leading() {
    return Container(
      child: InkWell(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop();
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

  _center() {
    return Container(
      child: RichText(
        text: TextSpan(
            text: TranslationBase.of(context).doctor,
            style: TextStyle(fontSize: 14, fontFamily: "LatoRegular", color: appBarIconColor)),
      ),
    );
  }

  _trailing() {
    return Container(
      child: bookmarkProcess
          ? SizedBox(
              height: size.convert(context, 20),
              width: size.convert(context, 20),
              child: FittedBox(child: Loading()),
            )
          : GestureDetector(
              onTap: alreadyAddedToFavourite ? _unbookmarkDoctor : _bookmarkDoctor,
              child: SvgPicture.asset(
                "assets/icons/bookmark.svg",
                color: alreadyAddedToFavourite ? Colors.red[800] : appBarIconColor,
                width: size.convert(context, 13),
                height: size.convert(context, 20),
              ),
            ),
    );
  }

  _body() {
    return _doctorDetailModel == null
        ? Center(child: Loading())
        : SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.convert(context, 10),
                  ),
                  _doctorInfo(),
                  SizedBox(
                    height: size.convert(context, 10),
                  ),
                  _doctorPatient(),
                  SizedBox(
                    height: size.convert(context, 10),
                  ),
                  _services(),
//                  SizedBox(
//                    height: size.convert(context, 10),
//                  ),
//                  _conditionTreated(),
                  SizedBox(
                    height: size.convert(context, 10),
                  ),
                  _ontherInfo(),
                  SizedBox(
                    height: size.convert(context, 10),
                  ),
//                  _patientExp(),
//                  SizedBox(height: size.convert(context, 10)),
                ],
              ),
            ),
          );
  }

  _doctorInfo() {
    String imageurl = "";
    if (_doctorDetailModel?.doctor?.doctorPicture != null) {
      imageurl = DOCTOR_IMAGE_URL + _doctorDetailModel?.doctor?.doctorPicture;
    } else {
      imageurl = _doctorDetailModel?.doctor?.doctorGender == "male"
          ? "assets/icons/doctor_male.png"
          : "assets/icons/doctor_female.png";
    }
    return Container(
      color: portionColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(
          horizontal: size.convert(context, 20), vertical: size.convert(context, 20)),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: size.convert(context, 70),
                        //color: Colors.deepOrange,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: circularImage(
                                  assetImage: _doctorDetailModel?.doctor?.doctorPicture == null
                                      ? true
                                      : false,
                                  imageUrl: imageurl,
                                  h: size.convert(context, 62),
                                  w: size.convert(context, 62)),
                            ),
                            Positioned(
                              //alignment: Alignment.bottomCenter,
                              top: size.convert(context, 55),
                              left: size.convert(context, 13),
                              child: Container(
                                width: size.convert(context, 34),
                                height: size.convert(context, 13),
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: SvgPicture.asset(
                                        "assets/icons/like.svg",
                                        height: size.convert(context, 6),
                                        width: size.convert(context, 6),
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Container(
                                      child: RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontFamily: "Lato-Regular",
                                            fontSize: size.convert(context, 6),
                                            color: Colors.white,
                                          ),
                                          text:
                                              "${_overAllRatingPer(_doctorDetailModel?.doctorFeedback[0]?.overallExperience == null ? 0.0 : double.parse(_doctorDetailModel?.doctorFeedback[0]?.overallExperience), _doctorDetailModel?.doctorFeedback[0]?.doctorCheckup == null ? 0.0 : double.parse(_doctorDetailModel?.doctorFeedback[0]?.doctorCheckup), _doctorDetailModel?.doctorFeedback[0]?.staffBehavior == null ? 0.0 : double.parse(_doctorDetailModel?.doctorFeedback[0]?.staffBehavior), _doctorDetailModel?.doctorFeedback[0]?.clinicEnvironment == null ? 0.0 : double.parse(_doctorDetailModel?.doctorFeedback[0]?.clinicEnvironment)).toStringAsFixed(1)}%",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text:
                                  "${_doctorDetailModel?.doctorFeedback[0]?.totalPatient == null ? 0.0 : _doctorDetailModel?.doctorFeedback[0]?.totalPatient} ${TranslationBase.of(context).patients}",
                              style: TextStyle(
                                fontSize: size.convert(context, 6),
                                color: portionColor,
                                fontFamily: "Lato-Regular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.convert(context, 8),
                ),
                Expanded(
                  child: Container(
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
                                    ("${_doctorDetailModel?.doctor?.title ?? ""} ${_doctorDetailModel?.doctor?.doctorName ?? ""} ") +
                                        " " +
                                        (_doctorDetailModel?.doctor?.doctorLastName ?? ""),
                                style: TextStyle(
                                    color: buttonColor,
                                    fontFamily: "LatoRegular",
                                    fontSize: size.convert(context, 14))),
                          ),
                        ),
//                        Container(
//                          child: RichText(
//                            maxLines: 1,
//                            text: TextSpan(
//                                text: _doctorDetailModel?.doctor?.??"",
//                                style: TextStyle(
//                                    color: portionColor,
//                                    fontFamily: "LatoRegular",
//                                    fontSize: size.convert(context, 10))),
//                          ),
//                        ),

//                        Container(
//                          child: RichText(
//                            maxLines: 1,
//                            text: TextSpan(
//                                text: "Gynecologist, Obsterician",
//                                style: TextStyle(
//                                    color: portionColor,
//                                    fontFamily: "LatoRegular",
//                                    fontSize: size.convert(context, 10))),
//                          ),
//                        ),
                        _listOfSpeciality(),
                        SizedBox(
                          height: size.convert(context, 20),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 12),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          "assets/icons/experience-5.png",
                          height: 15,
                          width: 15,
                          color: buttonColor,
                        ),
//                        child: Icon(
//                          Icons.star,
//                          size: size.convert(context, 10),
//                          color: buttonColor,
//                        ),
                      ),
                      SizedBox(
                        width: size.convert(context, 3),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text:
                                  "${_doctorDetailModel?.doctor?.experience ?? ""} ${TranslationBase.of(context).YearOfExperiencel}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          IcoFontIcons.eyeOpen,
                          color: buttonColor,
                          size: size.convert(context, 17),
                        ),
//                        child: SvgPicture.asset(
//                          "assets/icons/timer.svg",
//                          width: size.convert(context, 8),
//                          height: size.convert(context, 8),
//                          color: buttonColor,
//                        ),
                      ),
                      SizedBox(
                        width: size.convert(context, 3),
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: TranslationBase.of(context).viewAccount,
                              style: TextStyle(
                                fontFamily: "LatoBold",
                                fontSize: size.convert(context, 10),
                                color: Colors.black,
                              )),
                        ),
                      ),
                      Container(
                          child: RichText(
                        text: TextSpan(
                            text:
                                "  ${_doctorDetailModel?.doctorFeedback[0]?.viewAccount == null ? 0.0 : _doctorDetailModel?.doctorFeedback[0]?.viewAccount} ",
                            style: TextStyle(
                              fontFamily: "LatoBold",
                              fontSize: size.convert(context, 10),
                              color: logoColor,
                            )),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 13),
          ),
          Container(
            //height: size.convert(context, 41),
            padding: EdgeInsets.symmetric(vertical: size.convert(context, 10)),
            decoration: BoxDecoration(
                //color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(size.convert(context, 5)),
                border: Border.all(
                  color: buttonColor,
                  width: 1,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.convert(context, 45)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Container(
                                height: size.convert(context, 6),
                                width: size.convert(context, 6),
                                decoration: BoxDecoration(color: logoColor, shape: BoxShape.circle),
                              ),
                            ),
                            SizedBox(
                              width: size.convert(context, 3),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: _doctorDetailModel?.doctorAvailable ?? "",
                                    style: TextStyle(
                                      fontFamily: "LatoBold",
                                      color: logoColor,
                                      fontSize: size.convert(context, 8),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/icons/Group 1642.svg",
                              height: size.convert(context, 10),
                              width: size.convert(context, 10),
                            ),
                            SizedBox(
                              width: size.convert(context, 3),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: (_doctorDetailModel?.doctor?.doctorFee == 0 ||
                                          _doctorDetailModel?.doctor?.doctorFee == null)
                                      ? "${TranslationBase.of(context).fee}:  ${TranslationBase.of(context).free}"
                                      : "${TranslationBase.of(context).fee}: ${_doctorDetailModel?.doctor?.doctorFee ?? ""} ${TranslationBase.of(context).currencySymbol ?? ""}",
                                  style: TextStyle(
                                    fontSize: size.convert(context, 10),
                                    fontFamily: "LatoRegular",
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.convert(context, 5),
                ),
                Divider(
                  color: buttonColor,
                  thickness: 1,
                ),
                Container(
                  //color: Colors.cyan,
                  margin: EdgeInsets.symmetric(horizontal: size.convert(context, 45)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //change color for inactive
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Wrap(
                                runSpacing: 5,
                                children: _doctorDetailModel?.clinicAddress
                                    .map((clinicInfo) => Row(
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/icons/Map_1614.png",
                                              height: size.convert(context, 12),
                                            ),
//                                           SvgPicture.asset(
//                                            "assets/icons/mapMark.svg",
//                                            height: size.convert(context, 40),
//                                            width: size.convert(context, 40),
//                                          ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                double.parse(clinicInfo.from.replaceAll(":", "")) ==
                                                            0 &&
                                                        double.parse(clinicInfo.to
                                                                .replaceAll(":", "")) ==
                                                            0
                                                    ? ""
                                                    : "${clinicInfo.address}/${clinicInfo.name}(${clinicInfo.from.substring(0, 5)}-${clinicInfo.to.substring(0, 5)}),",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontFamily: "LatoRegular")),
                                          ],
                                        ))
                                    .toList()
                                    .cast<Widget>(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 13),
          ),
        ],
      ),
    );
  }

  Widget _listOfEducation() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: _doctorDetailModel.doctorEducations
          .map((education) => Text(education?.titleOfStudy ?? "",
              style: TextStyle(
                  color: portionColor,
                  fontFamily: "LatoRegular",
                  fontSize: size.convert(context, 10))))
          .toList(),
    );
  }

  Widget _listOfSpeciality() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: _doctorDetailModel.doctorSpecialities
          .map((speciality) => Text(speciality?.specialityName ?? "",
              style: TextStyle(
                  color: portionColor,
                  fontFamily: "LatoRegular",
                  fontSize: size.convert(context, 10))))
          .toList(),
    );
  }

  _doctorPatient() {
    return Container(
      color: portionColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(
          horizontal: size.convert(context, 26), vertical: size.convert(context, 15)),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset(
                          "assets/icons/review.svg",
                          color: buttonColor,
                          height: size.convert(context, 15),
                          width: size.convert(context, 15),
                        ),
                      ),
                      SizedBox(
                        width: size.convert(context, 4),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 12),
                              ),
                              text: TranslationBase.of(context).patientsWereHappyWith),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                        text:
                            "(${_doctorDetailModel?.doctorFeedback[0]?.staffBehavior == null ? 0 : _doctorDetailModel?.doctorFeedback[0]?.totalReview} ${TranslationBase.of(context).review})",
                        style: TextStyle(
                          fontSize: size.convert(context, 12),
                          fontFamily: "LatoRegular",
                          color: portionColor,
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 22),
          ),
          Container(
            //color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
//                    color: Colors.deepOrange,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: size.convert(context, 10)),
                            child: CircularPercentIndicator(
                              radius: size.convert(context, 69),
                              lineWidth: size.convert(context, 3),
                              percent: _ratingPer(_doctorDetailModel
                                          ?.doctorFeedback[0]?.overallExperience ==
                                      null
                                  ? 0.0
                                  : double.parse(
                                      _doctorDetailModel?.doctorFeedback[0]?.overallExperience)),
                              backgroundColor: Colors.white,
                              center: Container(
                                child: SvgPicture.asset(
                                  "assets/icons/ratingNew.svg",
                                  width: size.convert(context, 36),
                                  height: size.convert(context, 36),
                                ),
                              ),
                              progressColor: logoColor,
                              animation: true,
                              animationDuration: 2100,
                            ),
                          ),
                          Positioned(
                            top: size.convert(context, 1),
                            left: size.convert(context, 31),
                            child: Container(
                              height: size.convert(context, 15),
                              width: size.convert(context, 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  color: logoColor),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text:
                                          "${_doctorDetailModel?.doctorFeedback[0]?.overallExperience == null ? 0 : _doctorDetailModel?.doctorFeedback[0]?.overallExperience} %",
                                      style: TextStyle(
                                          fontSize: size.convert(context, 6),
                                          fontFamily: "LatoRegular",
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.convert(context, 10),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: TranslationBase.of(context).overallExperience,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 10),
                                    )),
                              ),
                            ),
//                            Container(
//                              child: RichText(
//                                text: TextSpan(
//                                    text:
//                                        TranslationBase.of(context).experience,
//                                    style: TextStyle(
//                                      color: Colors.black,
//                                      fontFamily: "LatoRegular",
//                                      fontSize: size.convert(context, 10),
//                                    )),
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //  color: Colors.deepOrange,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: size.convert(context, 10)),
                            child: CircularPercentIndicator(
                              radius: size.convert(context, 69),
                              lineWidth: size.convert(context, 3),
                              percent: _ratingPer(
                                  _doctorDetailModel?.doctorFeedback[0]?.doctorCheckup == null
                                      ? 0.0
                                      : double.parse(
                                          _doctorDetailModel?.doctorFeedback[0]?.doctorCheckup)),
                              backgroundColor: Colors.white,
                              center: Container(
                                child: SvgPicture.asset(
                                  "assets/icons/doctorNew.svg",
                                  width: size.convert(context, 36),
                                  height: size.convert(context, 36),
                                ),
                              ),
                              progressColor: logoColor,
                              animation: true,
                              animationDuration: 2100,
                            ),
                          ),
                          Positioned(
                            top: size.convert(context, 1),
                            left: size.convert(context, 31),
                            child: Container(
                              height: size.convert(context, 15),
                              width: size.convert(context, 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  color: logoColor),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text:
                                          "${_doctorDetailModel?.doctorFeedback[0]?.doctorCheckup == null ? 0 : _doctorDetailModel?.doctorFeedback[0]?.doctorCheckup} %",
                                      style: TextStyle(
                                          fontSize: size.convert(context, 6),
                                          fontFamily: "LatoRegular",
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.convert(context, 10),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: TranslationBase.of(context).doctorCheckup,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 10),
                                    )),
                              ),
                            ),
//                            Container(
//                              child: RichText(
//                                text: TextSpan(
//                                    text: "check-up",
//                                    style: TextStyle(
//                                      color: Colors.black,
//                                      fontFamily: "LatoRegular",
//                                      fontSize: size.convert(context, 10),
//                                    )),
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //  color: Colors.deepOrange,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: size.convert(context, 10)),
                            child: CircularPercentIndicator(
                              radius: size.convert(context, 69),
                              lineWidth: size.convert(context, 3),
                              percent: _ratingPer(
                                  _doctorDetailModel?.doctorFeedback[0]?.staffBehavior == null
                                      ? 0.0
                                      : double.parse(
                                          _doctorDetailModel?.doctorFeedback[0]?.staffBehavior)),
                              backgroundColor: Colors.white,
                              center: Container(
                                child: SvgPicture.asset(
                                  "assets/icons/staffNew.svg",
                                  width: size.convert(context, 36),
                                  height: size.convert(context, 36),
                                ),
                              ),
                              progressColor: logoColor,
                              animation: true,
                              animationDuration: 2100,
                            ),
                          ),
                          Positioned(
                            top: size.convert(context, 1),
                            left: size.convert(context, 31),
                            child: Container(
                              height: size.convert(context, 15),
                              width: size.convert(context, 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  color: logoColor),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text:
                                          "${_doctorDetailModel?.doctorFeedback[0]?.staffBehavior == null ? 0 : _doctorDetailModel?.doctorFeedback[0]?.staffBehavior} %",
                                      style: TextStyle(
                                          fontSize: size.convert(context, 6),
                                          fontFamily: "LatoRegular",
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.convert(context, 10),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: TranslationBase.of(context).staffBehavior,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 10),
                                    )),
                              ),
                            ),
//                            Container(
//                              child: RichText(
//                                text: TextSpan(
//                                    text: "behavior",
//                                    style: TextStyle(
//                                      color: Colors.black,
//                                      fontFamily: "LatoRegular",
//                                      fontSize: size.convert(context, 10),
//                                    )),
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //  color: Colors.deepOrange,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: size.convert(context, 10)),
                            child: CircularPercentIndicator(
                              radius: size.convert(context, 69),
                              lineWidth: size.convert(context, 3),
                              percent: _ratingPer(_doctorDetailModel
                                          ?.doctorFeedback[0]?.clinicEnvironment ==
                                      null
                                  ? 0.0
                                  : double.parse(
                                      _doctorDetailModel?.doctorFeedback[0]?.clinicEnvironment)),
                              backgroundColor: Colors.white,
                              center: Container(
                                child: SvgPicture.asset(
                                  "assets/icons/filledoutlineNew.svg",
                                  width: size.convert(context, 36),
                                  height: size.convert(context, 36),
                                ),
                              ),
                              progressColor: logoColor,
                              animation: true,
                              animationDuration: 2100,
                            ),
                          ),
                          Positioned(
                            top: size.convert(context, 1),
                            left: size.convert(context, 31),
                            child: Container(
                              height: size.convert(context, 15),
                              width: size.convert(context, 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  color: logoColor),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text:
                                          "${_doctorDetailModel?.doctorFeedback[0]?.clinicEnvironment == null ? 0 : _doctorDetailModel?.doctorFeedback[0]?.clinicEnvironment} %",
                                      style: TextStyle(
                                          fontSize: size.convert(context, 6),
                                          fontFamily: "LatoRegular",
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.convert(context, 10),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: TranslationBase.of(context).clinicEnvironment,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 10),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _services() {
    return Container(
      color: portionColor.withOpacity(0.1),
      //margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
      padding: EdgeInsets.symmetric(
          vertical: size.convert(context, 15), horizontal: size.convert(context, 20)),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
                    "assets/icons/pay.svg",
                    width: size.convert(context, 15),
                    height: size.convert(context, 15),
                    color: buttonColor,
                  ),
                ),
                SizedBox(
                  width: size.convert(context, 5),
                ),
                Container(
                  child: RichText(
                    maxLines: 1,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "LatoRegular",
                        fontSize: size.convert(context, 12),
                      ),
                      text: TranslationBase.of(context).services,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.convert(context, 5),
                ),
//                Container(
//                  child: RichText(
//                    maxLines: 1,
//                    text: TextSpan(
//                      style: TextStyle(
//                        color: appColor,
//                        fontFamily: "LatoRegular",
//                        fontSize: size.convert(context, 12),
//                        decoration: TextDecoration.underline,
//                      ),
//                      text: "( view all )",
//                    ),
//                  ),
//                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 13),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 6),
              padding: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
              itemCount: _doctorDetailModel?.doctorServices?.length,
              itemBuilder: (context, index) {
                return Row(
                  children: <Widget>[
                    Container(
                      width: size.convert(context, 3),
                      height: size.convert(context, 3),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                    ),
                    SizedBox(
                      width: size.convert(context, 8),
                    ),
                    Expanded(
                      child: Container(
                        child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              text: _doctorDetailModel?.doctorServices[index]?.serviceName ?? "",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  double _ratingPer(double val) {
    if (val != 0 || val != null) {
      return val / 100;
    } else {
      return 0.0;
    }
  }

  double _overAllRatingPer(
    double val1,
    double val2,
    double val3,
    double val4,
  ) {
    // print("${val1}");
    // print("${val2}");
    // print("${val3}");
    // print("${val4}");
    double total = (val1 + val2 + val3 + val4) / 4;
    // print("${total}");
    return total;
  }

  _conditionTreated() {
    return Container(
      color: portionColor.withOpacity(0.1),
      //margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
      padding: EdgeInsets.symmetric(
          vertical: size.convert(context, 15), horizontal: size.convert(context, 20)),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
                    "assets/icons/pay.svg",
                    width: size.convert(context, 15),
                    height: size.convert(context, 15),
                    color: buttonColor,
                  ),
                ),
                SizedBox(
                  width: size.convert(context, 5),
                ),
                Container(
                  child: RichText(
                    maxLines: 1,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "LatoRegular",
                        fontSize: size.convert(context, 12),
                      ),
                      text: "Conditions treated ",
                    ),
                  ),
                ),
                SizedBox(
                  width: size.convert(context, 5),
                ),
                Container(
                  child: RichText(
                    maxLines: 1,
                    text: TextSpan(
                      style: TextStyle(
                        color: buttonColor,
                        fontFamily: "LatoRegular",
                        fontSize: size.convert(context, 12),
                        decoration: TextDecoration.underline,
                      ),
                      text: "( view all )",
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 13),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: size.convert(context, 40)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: size.convert(context, 40)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: size.convert(context, 40)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: size.convert(context, 40)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: size.convert(context, 40)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: size.convert(context, 3),
                        height: size.convert(context, 3),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              text: "Antenatal Checkup",
                              style: TextStyle(
                                color: portionColor,
                                fontSize: size.convert(context, 10),
                                fontFamily: "LatoRegular",
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ontherInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.convert(context, 15)),
      color: portionColor.withOpacity(0.1),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
            child: Row(
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
                    "assets/icons/information.svg",
                    height: size.convert(context, 11),
                    width: size.convert(context, 11),
                    color: buttonColor,
                  ),
                ),
                SizedBox(
                  width: size.convert(context, 10),
                ),
                Container(
                  child: RichText(
                    maxLines: 1,
                    text: TextSpan(
                        text: TranslationBase.of(context).otherInformaion,
                        style: TextStyle(
                          fontFamily: "LatoRegular",
                          fontSize: size.convert(context, 12),
                          color: Colors.black,
                        )),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Divider(
            color: portionColor,
            height: 2,
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: RichText(
                  text: TextSpan(
                      text: TranslationBase.of(context).education,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      )),
                )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      educationExpand = !educationExpand;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white.withOpacity(0.0),
                    child: Icon(
                      educationExpand ? Icons.remove : Icons.add,
                      size: size.convert(context, 14),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          !educationExpand
              ? SizedBox()
              : SizedBox(
                  height: size.convert(context, 10),
                ),
          !educationExpand
              ? SizedBox()
              : ListView.builder(
                  itemCount: _doctorDetailModel.doctorEducations.length,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
                  itemBuilder: (context, index) => Row(
                        children: <Widget>[
                          Container(
                            width: size.convert(context, 3),
                            height: size.convert(context, 3),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                          ),
                          SizedBox(
                            width: size.convert(context, 8),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                      text:
                                          _doctorDetailModel?.doctorEducations[index]?.schoolName ??
                                              "",
                                      style: TextStyle(
                                        color: portionColor,
                                        fontSize: size.convert(context, 10),
                                        fontFamily: "LatoRegular",
                                      )),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: _doctorDetailModel
                                              ?.doctorEducations[index]?.titleOfStudy ??
                                          "",
                                      style: TextStyle(
                                        color: portionColor,
                                        fontSize: size.convert(context, 10),
                                        fontFamily: "LatoRegular",
                                      )),
                                ),
                              ),
                              Container(
                                child: RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: (_doctorDetailModel
                                                  ?.doctorEducations[index]?.startDate ??
                                              "-") +
                                          " - " +
                                          (_doctorDetailModel?.doctorEducations[index]?.endDate ??
                                              "-"),
                                      style: TextStyle(
                                        color: portionColor,
                                        fontSize: size.convert(context, 10),
                                        fontFamily: "LatoRegular",
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Divider(
            color: portionColor,
            height: 2,
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: RichText(
                  text: TextSpan(
                      text: TranslationBase.of(context).specialization,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      )),
                )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      specializationExpand = !specializationExpand;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white.withOpacity(0.0),
                    child: Icon(
                      specializationExpand ? Icons.remove : Icons.add,
                      size: size.convert(context, 14),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          !specializationExpand
              ? SizedBox()
              : SizedBox(
                  height: size.convert(context, 15),
                ),

          !specializationExpand
              ? SizedBox()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) => Row(
                        children: <Widget>[
                          Container(
                            width: size.convert(context, 3),
                            height: size.convert(context, 3),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: portionColor),
                          ),
                          SizedBox(
                            width: size.convert(context, 8),
                          ),
                          Container(
                            child: RichText(
                              maxLines: 1,
                              text: TextSpan(
                                  text: _doctorDetailModel
                                          ?.doctorSpecialities[index]?.specialityName ??
                                      "",
                                  style: TextStyle(
                                    color: portionColor,
                                    fontSize: size.convert(context, 10),
                                    fontFamily: "LatoRegular",
                                  )),
                            ),
                          ),
                        ],
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: _doctorDetailModel?.doctorSpecialities?.length ?? 0),

//          Container(
//            padding:
//            EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
////                Container(
////                  child:
////                ),
////                Container(
////                  padding: EdgeInsets.only(right: size.convert(context, 40)),
////                  child: Row(
////                    children: <Widget>[
////                      Container(width: size.convert(context, 3),
////                        height: size.convert(context, 3),
////                        decoration: BoxDecoration(
////                            shape: BoxShape.circle,
////                            color: portionColor
////                        ),
////                      ),
////                      SizedBox(width: size.convert(context, 8),),
////                      Container(child: RichText(
////                        maxLines: 1,
////                        text: TextSpan(
////                            text: "Antenatal Checkup",
////                            style: TextStyle(
////                              color: portionColor,
////                              fontSize: size.convert(context, 10),
////                              fontFamily: "LatoRegular",
////                            )
////                        ),
////                      ),),
////                    ],
////                  ),)
//              ],
//            ),
//          ),

          SizedBox(
            height: size.convert(context, 10),
          ),
//          Divider(
//            color: portionColor,
//            height: 2,
//          ),
//          SizedBox(
//            height: size.convert(context, 10),
//          ),
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                    child: RichText(
//                  maxLines: 1,
//                  text: TextSpan(
//                      text: TranslationBase.of(context).professionalMembership,
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: size.convert(context, 12),
//                        fontFamily: "LatoRegular",
//                      )),
//                )),
//                GestureDetector(
//                  onTap: () {
//                    setState(() {
//                      professionalMemebershipExpand =
//                          !professionalMemebershipExpand;
//                    });
//                  },
//                  child: Container(
//                    padding: EdgeInsets.all(10),
//                    color: Colors.white.withOpacity(0.0),
//                    child: Icon(
//                      professionalMemebershipExpand ? Icons.remove : Icons.add,
//                      size: size.convert(context, 14),
//                      color: Colors.black,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),

          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

//  _patientExp() {
//    return Container(
//      color: portionColor.withOpacity(0.1),
//      padding: EdgeInsets.symmetric(vertical: size.convert(context, 15)),
//      child: Column(
//        children: <Widget>[
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
//            child: Row(
//              children: <Widget>[
//                Container(
//                  child: SvgPicture.asset(
//                    "assets/icons/smile.svg",
//                    height: size.convert(context, 11),
//                    width: size.convert(context, 11),
//                    color: appColor,
//                  ),
//                ),
//                SizedBox(
//                  width: size.convert(context, 10),
//                ),
//                Container(
//                  child: RichText(
//                    maxLines: 1,
//                    text: TextSpan(
//                        text: "Patient Experience",
//                        style: TextStyle(
//                          fontFamily: "LatoRegular",
//                          fontSize: size.convert(context, 12),
//                          color: Colors.black,
//                        )),
//                  ),
//                )
//              ],
//            ),
//          ),
//          SizedBox(
//            height: size.convert(context, 7),
//          ),
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: 40),
//            child: RichText(
//              maxLines: 2,
//              text: TextSpan(
//                  text:
//                      "These are the patient opinions about their visit to the doctor collected"
//                      "online and through call center.",
//                  style: TextStyle(
//                    fontFamily: "LatoRegular",
//                    fontSize: 10,
//                    color: portionColor,
//                  )),
//            ),
//          ),
//          SizedBox(
//            height: size.convert(context, 15),
//          ),
//          Container(
//            child: Column(
//              children: <Widget>[
//                Container(
//                  margin: EdgeInsets.symmetric(
//                      horizontal: size.convert(context, 33)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Container(
//                        child: Row(
//                          children: <Widget>[
//                            Container(
//                              child: circularImage(
//                                imageUrl: "assets/icons/person2.png",
//                                h: size.convert(context, 31),
//                                w: size.convert(context, 31),
//                              ),
//                            ),
//                            SizedBox(
//                              width: size.convert(context, 4),
//                            ),
//                            Container(
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Container(
//                                    child: RichText(
//                                      text: TextSpan(
//                                          text: "Jayden james",
//                                          style: TextStyle(
//                                            color: Colors.black,
//                                            fontSize: size.convert(context, 12),
//                                            fontFamily: "LatoRegular",
//                                          )),
//                                    ),
//                                  ),
//                                  Container(
//                                    child: RichText(
//                                      text: TextSpan(
//                                          text: "25-02-2020",
//                                          style: TextStyle(
//                                            color: portionColor,
//                                            fontSize: size.convert(context, 8),
//                                            fontFamily: "LatoRegular",
//                                          )),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      Container(
//                        child: SmoothStarRating(
////                      onRatingChanged: (v) {
////                        rating = v;
////                        setState(() {
////                          print(rating);
////                        });
////                      },
//                          starCount: 5,
//                          rating: rating,
//                          size: 13.0,
//                          color: buttonColor,
//
//                          spacing: 0.0,
//                          defaultIconData: Icons.star,
//                          borderColor: Color(0xff7e7e7e),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.only(
//                      left: size.convert(context, 76),
//                      right: size.convert(context, 36),
//                      top: size.convert(context, 12)),
//                  child: RichText(
//                    text: TextSpan(
//                      style: TextStyle(
//                        fontFamily: "LatoRegular",
//                        fontSize: size.convert(context, 8),
//                        color: portionColor,
//                      ),
//                      text:
//                          "The Good Doctor would really like to make you feel good.  And that's always a good thing. The Good Doctor would really like to make you feel good.  And that's always a good thing.",
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  height: size.convert(context, 12),
//                ),
//                Padding(
//                  padding: EdgeInsets.symmetric(
//                      horizontal: size.convert(context, 32)),
//                  child: Divider(
//                    height: 2,
//                    color: portionColor,
//                  ),
//                ),
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//  }

  _button() {
    return Container(
      child: GestureDetector(
        onTap: () {
          print("Click on book Appointments from doctor profile");
          getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
              type: PageTransitionType.rightToLeft,
              child: selectAppointmentDate(
                doctorModel: _doctorDetailModel.doctor,
              )));
        },
        child: Container(
          height: size.convert(context, 40),
          margin: EdgeInsets.symmetric(horizontal: size.convert(context, 20)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.convert(context, 5)), color: buttonColor),
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

  _unbookmarkDoctor() async {
    setState(() {
      bookmarkProcess = true;
    });

    String temp1 = await UserModel.getUserId;
    int userId = int.parse(temp1);

    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(url: UN_BOOKMARK_DOCTOR_URL, body: {
      'user_id': userId,
      'doctor_id': _doctorDetailModel.doctor.doctorID,
    });

    setState(() {
      bookmarkProcess = false;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context);
      return;
    }

    if (response is Response) {
      setState(() {
        alreadyAddedToFavourite = !alreadyAddedToFavourite;
      });
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: TranslationBase.of(context).unbookmarkSuccess, leadingIcon: Icons.check);
    }
  }

  _bookmarkDoctor() async {
    setState(() {
      bookmarkProcess = true;
    });

    String temp2 = await UserModel.getUserId;
    int userId = int.parse(temp2);

    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(url: BOOKMARK_DOCTOR_URL, body: {
      'user_id': userId,
      'doctor_id': _doctorDetailModel.doctor.doctorID,
    });

    setState(() {
      bookmarkProcess = false;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context);
      return;
    }

    if (response is Response) {
      setState(() {
        alreadyAddedToFavourite = !alreadyAddedToFavourite;
      });

      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: TranslationBase.of(context).bookmarkSuccess, leadingIcon: Icons.check);
    }
  }
}
