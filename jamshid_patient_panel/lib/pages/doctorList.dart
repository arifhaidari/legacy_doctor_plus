import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/doctor/doctor_model.dart';
import 'package:doctor_app/model/doctor/filter_model.dart';
import 'package:doctor_app/model/doctor_speciality_model.dart';
import 'package:doctor_app/model/specaility/specailty.dart';
import 'package:doctor_app/pages/doctorDetail.dart';
import 'package:doctor_app/pages/selectAppointmentDate.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/customCheckBox.dart';
import 'package:doctor_app/repeatedWidgets/shimmerListLoader.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class doctorList extends StatefulWidget {
  final SpecialityModel specialityModel;
  final int clinicID;
  // final String clinicID;
  final String districtName;

  const doctorList({Key key, this.specialityModel, this.districtName, this.clinicID})
      : super(key: key);

  @override
  _doctorListState createState() => _doctorListState();
}

class _doctorListState extends State<doctorList> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedItem = "Self";

  // FilterModel filterModelList;

  bool useFilter = false;

  ///0> all
  ///1> today
  ///2> next3days
  int availability = 0;

  ///0> both
  ///1>female
  ///2>male
  int gender = 0;

//  List<DoctorModel> _doctorList = [];

//  DoctorModelPagination _doctorModelPagination;

  TextEditingController _textEditingController = TextEditingController();
  DoctorSpecialityModel doctorSpecialityModel;
  bool isDoctorloading = true;
  bool isbodyLoad = false;
  DoctorSpecialityModel doctorSpecialitySearchModel;

  FilterModel _filterModel;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_searchInput);
    Future.delayed(Duration.zero, () {
      getDoctorAndSpeciality(context);
    });

    _getDoctorList();
  }

  _searchInput() {
    if (_textEditingController.text.length >= 3 && doctorSpecialityModel != null) {
      doctorSpecialitySearchModel = DoctorSpecialityModel();
      doctorSpecialitySearchModel.specialitys = doctorSpecialityModel.specialitys
          .where((speciality) => speciality.specialityName
              .toLowerCase()
              .contains(_textEditingController.text.toLowerCase()))
          .toList();
      doctorSpecialitySearchModel.doctors = doctorSpecialityModel.doctors
          .where((doctor) =>
              doctor.doctorName.toLowerCase().contains(_textEditingController.text.toLowerCase()))
          .toList();
      doctorSpecialitySearchModel.allClinicHospital = doctorSpecialityModel.allClinicHospital
          .where((clinic) =>
              clinic.name.toLowerCase().contains(_textEditingController.text.toLowerCase()))
          .toList();
    } else {
      doctorSpecialitySearchModel = null;
    }
    setState(() {});
  }

  getDoctorAndSpeciality(BuildContext context) async {
    var response = await API(context: context, showSnackbarForError: true, scaffold: _scaffoldKey)
        .get(url: SPECIALITY_DOCTOR_URL + "/en");
    // .get(url: SPECIALITY_DOCTOR_URL + "/${TranslationBase.of(context).Langkey}");

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldKey, context, btnFun: () {
        _getDoctorList();
        getDoctorAndSpeciality(context);
      });
      return;
    }

    if (response is Response) {
      doctorSpecialityModel = DoctorSpecialityModel.fromJson(response.data);

//      if(doctorSpecialityModel!=null){
//        isDoctorModelEmpty = false;
//      }
//      else{
//        isDoctorModelEmpty = false;
//      }

    }
    isDoctorloading = false;
    if (mounted) setState(() {});
  }

  _getDoctorList() async {
    setState(() {
      _filterModel = null;
    });

    Map body = {'special_id': widget?.specialityModel?.specialityID ?? "null"};
    if (widget.districtName != "null")
      body.addAll({'District_name': widget.districtName});
    else
      body.addAll({'District_name': 'null'});

    body.addAll({
      'available': widget?.clinicID != null
          ? "all"
          : availability == 0
              ? 'all'
              : availability == 1
                  ? 'today'
                  : 'next_days',
      'gender': widget?.clinicID != null
          ? "both"
          : gender == 0
              ? 'both'
              : gender == 1
                  ? 'female'
                  : 'male',
      'clinic_id': widget?.clinicID ?? "null"
    });

    print(body);
    int _currentPage = 1;
    int itemNo = 20;

    while (itemNo != -351) {
      var response = await API(scaffold: _scaffoldKey, context: context, showSnackbarForError: true)
          .post(url: FILTER_URL + "?page=$_currentPage", body: body);

      if (response == NO_CONNECTION) {
        // CustomSnackBar.SnackBarInternet(_scaffoldKey, context,
        //     btnFun: _getDoctorList);
        return;
      }

      if (response is Response) {
        FilterModel _data = FilterModel.fromJson(response.data);
        if (_data != null) {
          if (_currentPage == 1) {
            _filterModel = _data;
            // _filterModel?.doctor?.doctors?.sort((a, b) {
            //   return double.parse(b.doctorFeedback[0].stars)
            //       .compareTo(double.parse(a.doctorFeedback[0].stars));
            // });

          } else {
            if (_data != null && _data.doctorAvailableNext3Days != "false") {
              print('===============valeu of _filterModel.doctor.doctors.length');
              // print(_filterModel.doctor.doctors.length);
              _filterModel.doctor.doctors.addAll(_data.doctor.doctors);
            } else {
              print('this conditon true in else =========------------');
              itemNo = -351;
            }
          }
        }
        isbodyLoad = true;
        setState(() {});
        //
        _currentPage++;
      } else {
        itemNo = -351;
      }

      //  _getAllDoctorStarAndAvailability();
    }
  }

//  _getAllDoctorStarAndAvailability() async {
//    _filterModel.doctor.doctors.forEach((doctor) {
//      _getDoctorStarAndAvailability(doctor.doctorID);
//    });
//  }

//  _getDoctorStarAndAvailability(String id) async {
//    var response = await API(
//            context: context,
//            showSnackbarForError: false,
//            scaffold: _scaffoldKey)
//        .post(url: SPEC_STAR_DOCTOR_URL, body: {'doctor_id': id});
//
//    if (response == NO_CONNECTION) {
////      CustomSnackBar.SnackBarInternet(_scaffoldKey, context,
////          btnFun: getDoctorAndSpeciality);
//      return;
//    }
//
//    if (response is Response) {
//      _filterModel.doctor.doctors
//          .firstWhere((doctor) => doctor.doctorID == id)
//          .setSpecStarModel = (SpecStarModel.fromJson(response.data));
//      if (mounted) setState(() {});
//    }
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
      body: useFilter ? _filterBody() : _body(),
    );
  }

  _leading() {
    return Container(
      child: GestureDetector(
        onTap: () {
          if (useFilter) {
            setState(() {
              useFilter = !useFilter;
              availability = 0;
              gender = 0;
            });
            _getDoctorList();
          } else
            getIt<GlobalSingleton>().navigationKey.currentState.pop();
        },
        child: useFilter
            ? Container(
                child: Text(
                  TranslationBase.of(context).reset,
                  style: TextStyle(fontSize: 14, fontFamily: "LatoRegular", color: appBarIconColor),
                ),
              )
            : Container(
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
    return useFilter
        ? Container(
            child: Text(
              TranslationBase.of(context).filter,
              style: TextStyle(
                color: appBarIconColor,
                fontFamily: "LatoRegular",
                fontSize: size.convert(context, 14),
              ),
            ),
          )
        : Container(
            child: RichText(
              text: TextSpan(
                  text:
                      "${widget?.specialityModel?.specialityName ?? ""} ${widget?.districtName != null ? "  (${widget?.districtName ?? ""})" : ""}",
                  style: TextStyle(fontSize: 14, fontFamily: "LatoRegular", color: Colors.white)),
            ),
          );
  }

  _trailing() {
    return Container(
      child: useFilter
          ? GestureDetector(
              onTap: () {
                setState(() {
                  useFilter = false;
                });
              },
              child: Icon(
                Icons.clear,
                color: appBarIconColor,
                size: size.convert(context, 18),
              ))
          : InkWell(
              onTap: detailPad,

              child: Transform.rotate(
                angle: 180 * math.pi / 165,
                child: Icon(
                  IcoFontIcons.uiCall,
                  color: appBarIconColor,
                ),
              ),
//            child: Image.asset(
//                "assets/icons/phone.png",
//                color: appBarIconColor,
//              ),
            ),
    );
  }

  _body() {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                //color: Colors.deepOrangeAccent,
                //height: 200,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    doctorSpecialityModel == null && isDoctorloading
                        ? serachFieldShimmerLoader()
                        : Container(
                            child: CustomTextField(
                              hints: TranslationBase.of(context).searchTitle,
                              iconWidget: Icon(
                                IcoFontIcons.search2,
                                size: 17,
                              ),
//                                Image.asset(
//                                  "assets/icons/searchIcon.png",
//                                ),
                              textEditingController: _textEditingController,
                            ),
                          ),
                    SizedBox(
                      height: size.convert(context, 8),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            useFilter = true;
                          });
                        },
                        child: Container(
                            width: size.convertWidth(context, 120),
                            height: size.convert(context, 30),
                            padding:
                                EdgeInsets.symmetric(horizontal: size.convertWidth(context, 10)),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: size.convert(context, 1), color: buttonColor),
                                borderRadius: BorderRadius.circular(size.convert(context, 3))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(),
                                Text(
                                  TranslationBase.of(context).filter,
                                  style: TextStyle(
                                      color: buttonColor,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 13)),
                                ),
                                Icon(
                                  IcoFontIcons.simpleDown,
                                  color: buttonColor,
                                  size: size.convert(context, 18),
                                )
//                      dropDown(
//                        selectedItem: selectedItem,
//                        onItemSelect: (val){
//                          setState(() {
//                            selectedItem = val;
//                          });
//                        },
//                      ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Container(
                          child: RichText(
                            maxLines: 1,
                            text: TextSpan(
                                // text: 'the search result',
                                text: (_filterModel != null &&
                                        _filterModel?.doctor != null &&
                                        _filterModel?.doctor?.doctors.isNotEmpty)
                                    ? "${TranslationBase.of(context).ShowingTop} ${_filterModel?.doctor?.doctors?.length ?? 0} ${widget?.specialityModel?.specialityName ?? ""}"
                                    : "${TranslationBase.of(context).noResultFound}",
                                // "${TranslationBase.of(context).ShowingTop} ${_filterModel?.doctor?.doctors?.length ?? 0} ${widget?.specialityModel?.specialityName ?? ""} ${TranslationBase.of(context).In} ${widget?.districtName ?? TranslationBase.of(context).allDistrict}",
                                style: TextStyle(
                                  color: Color(0xff7e7e7e),
                                  fontFamily: "LatoRegular",
                                  fontSize: 12,
                                )),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _filterModel == null
                    ? Center(
                        child: ShimmerList(),
                      )
                    : (_filterModel?.doctor?.doctors?.length ?? 0) == 0
                        ? Center(
                            child: Text(TranslationBase.of(context).noDoctorMatched),
                            // child: Text("No Doctor Found"),
                          )
                        : SingleChildScrollView(
                            child: Container(
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: _filterModel?.doctor?.doctors?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  int i = 0;
                                  List<SpecialityModel> _specialityModel = [];
                                  _filterModel?.doctor?.doctors[index].speciality.forEach((f) {
                                    if (i < 3) {
                                      _specialityModel.add(f);
                                    }
                                    i++;
                                  });
                                  print("index $index");
                                  // print('////////////');
                                  // print(_filterModel.doctor.doctors[index].doctorGender);
                                  return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.convertWidth(context, 13)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.convertWidth(context, 10),
                                          vertical: size.convert(context, 15)),
                                      color: portionColor.withOpacity(0.1),
                                      //height: 132,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                print("individual doctor detail");
                                                getIt<GlobalSingleton>()
                                                    .navigationKey
                                                    .currentState
                                                    .push(PageTransition(
                                                        child: doctorDetail(
                                                          doctorId: _filterModel?.doctor
                                                                  ?.doctors[index].doctorID ??
                                                              "",
                                                          key: UniqueKey(),
                                                        ),
                                                        type: PageTransitionType
                                                            .leftToRightWithFade));
                                              },
                                              child: Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: circularImage(
                                                        assetImage: _filterModel.doctor
                                                                    .doctors[index].doctorPicture ==
                                                                null
                                                            ? true
                                                            : false,
                                                        imageUrl: _filterModel.doctor.doctors[index]
                                                                    .doctorPicture !=
                                                                null
                                                            ? DOCTOR_IMAGE_URL +
                                                                (_filterModel
                                                                        ?.doctor
                                                                        ?.doctors[index]
                                                                        ?.doctorPicture ??
                                                                    "")
                                                            : (_filterModel.doctor.doctors[index]
                                                                        .doctorGender ==
                                                                    "male"
                                                                ? "assets/icons/doctor_male.png"
                                                                : "assets/icons/doctor_female.png"),
                                                        h: 36,
                                                        w: 36,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          //mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              width:
                                                                  size.convertWidth(context, 150),
                                                              child: RichText(
                                                                maxLines: 2,
                                                                text: TextSpan(
                                                                    text:
                                                                        "${_filterModel?.doctor?.doctors[index].title ?? ""} ${_filterModel?.doctor?.doctors[index].doctorName}",
                                                                    style: TextStyle(
                                                                      color: buttonColor,
                                                                      fontSize: 14,
                                                                      fontFamily: "Lato-Regular",
                                                                    )),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: size.convert(context, 4),
                                                            ),
                                                            _filterModel?.doctor?.doctors[index]
                                                                        .speciality ==
                                                                    null
                                                                ? Container()
                                                                : Container(
                                                                    width: size.convertWidth(
                                                                        context, 170),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Wrap(
                                                                            children:
                                                                                _specialityModel
                                                                                    .map(
                                                                                        (data) =>
                                                                                            Text(
                                                                                              data.specialityName +
                                                                                                  ",",
                                                                                              style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontSize: 10,
                                                                                                  fontFamily: "LatoRegular"),
                                                                                              maxLines:
                                                                                                  1,
                                                                                            ))
                                                                                    .toList()
                                                                                    .cast<Widget>(),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
//                                                          Container(
//                                                            height: 15,
//                                                            width: 170,
//                                                            child: ListView.separated(
//                                                                itemBuilder:  (BuildContext context, int spIndex){
//                                                                  return RichText(
//                                                                    maxLines: 2,
//                                                                    text: TextSpan(text: "${_filterModel
//                                                                        ?.doctor
//                                                                        ?.doctors[
//                                                                    index]
//                                                                        ?.speciality[spIndex].specialityName}," ??
//                                                                        "",
//                                                                        style: TextStyle(
//                                                                            fontFamily:
//                                                                            "LatoRegular",
//                                                                            fontSize: 10,
//                                                                            color: Color(
//                                                                                0xff000000))
//                                                                    ),
//                                                                );
//                                                                }, separatorBuilder: (BuildContext context, int spIndex){
//                                                                  return Container(
//                                                                    width: 3,
//                                                                  );
//                                                            },
//                                                              itemCount: _filterModel?.doctor?.doctors[index].speciality.length??0,
//                                                              physics: ScrollPhysics(),
//                                                              shrinkWrap: true,
//                                                              scrollDirection: Axis.horizontal,
//
//                                                            )
//                                                          ),
                                                            SizedBox(
                                                              height: size.convert(context, 4),
                                                            ),
                                                            Container(
                                                              width:
                                                                  size.convertWidth(context, 170),
                                                              //color: Colors.red,
                                                              child: Row(
                                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Container(
//                                                                  child: SvgPicture.asset(
//                                                                    "assets/icons/mapMark.svg",
//                                                                    height: size.convert(context, 20),
//                                                                    width: size.convert(context, 20),
//                                                                  ),
                                                                    child: Image.asset(
                                                                      "assets/icons/Map_1614.png",
                                                                      height: 15,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
//                                                                _filterModel?.doctor?.doctors[index].address == null ? Container():
//                                                                  Expanded(
//                                                                    child: Wrap(
//                                                                      children: _filterModel?.doctor?.doctors[index].address.map((data)=>Text(data.address+", ",style: TextStyle(
//                                                                                        color: Color(
//                                                                                            0xff7e7e7e),
//                                                                                        fontSize:
//                                                                                        10,
//                                                                                        fontFamily:
//                                                                                        "Lato-Regular"))).toList().cast<Widget>(),
//                                                                    ),
//                                                                  ),
//                                                                Expanded(
//                                                                  child: Align(
//                                                                    alignment: Alignment.center,
//                                                                    child: Container(
//                                                                      ///width: 100,
//                                                                      height:30,
//                                                                      child: Container(
//                                                                        child: ListView.separated(
//                                                                              itemBuilder: (BuildContext context , int addIndex){
//                                                                                return Text(
//                                                                                    _filterModel
//                                                                                        ?.doctor
//                                                                                        ?.doctors[
//                                                                                    index]
//                                                                                        ?.address[addIndex].address ??
//                                                                                        "",
//                                                                                    style: TextStyle(
//                                                                                        color: Color(
//                                                                                            0xff7e7e7e),
//                                                                                        fontSize:
//                                                                                        10,
//                                                                                        fontFamily:
//                                                                                        "Lato-Regular"));
//                                                                              },
//                                                                              separatorBuilder: (BuildContext context, int addIndex){
//                                                                                return Container(width: 3,);
//                                                                              },
//                                                                              itemCount: _filterModel?.doctor?.doctors[index].address.length??0,
//                                                                            scrollDirection: Axis.horizontal,
//                                                                             shrinkWrap: true,
//                                                                             physics: ScrollPhysics(),
//                                                                          ),
//                                                                          )
//
//                                                                    ),
//                                                                  ),
//                                                                ),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment.centerLeft,
                                                                      child: Text(
                                                                          _filterModel
                                                                              ?.doctor
                                                                              ?.doctors[index]
                                                                              .address[0]
                                                                              .address,
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Color(0xff7e7e7e),
                                                                              fontSize: 10,
                                                                              fontFamily:
                                                                                  "Lato-Regular"))),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: size.convert(context, 15),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Container(
                                                                  // color: Colors.deepOrange,
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        child: RichText(
                                                                          maxLines: 1,
                                                                          text: TextSpan(
                                                                              text: (_filterModel
                                                                                              ?.doctor
                                                                                              ?.doctors[
                                                                                                  index]
                                                                                              ?.doctorFee ==
                                                                                          0 ||
                                                                                      _filterModel
                                                                                              ?.doctor
                                                                                              ?.doctors[
                                                                                                  index]
                                                                                              ?.doctorFee ==
                                                                                          null)
                                                                                  ? "${TranslationBase.of(context).fee}:  ${TranslationBase.of(context).free}"
                                                                                  : "${TranslationBase.of(context).fee}: ${_filterModel?.doctor?.doctors[index]?.doctorFee ?? ""} ${TranslationBase.of(context).currencySymbol ?? ""}",
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    "LatoRegular",
                                                                                fontSize: 11,
                                                                                color: Colors.black,
                                                                              )),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: size.convert(context, 3),
                                                                ),
                                                                Container(
                                                                  //color: Colors.deepOrange,
                                                                  child: Row(
                                                                    children: <Widget>[
                                                                      Container(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                              text:
                                                                                  "${TranslationBase.of(context).experience}: ",
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 11,
                                                                                fontFamily:
                                                                                    "LatoRegular",
                                                                              )),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: RichText(
                                                                          text: TextSpan(
                                                                              text: (_filterModel
                                                                                          ?.doctor
                                                                                          ?.doctors[
                                                                                              index]
                                                                                          ?.experience ??
                                                                                      "") +
                                                                                  " ${TranslationBase.of(context).year}",
                                                                              style: TextStyle(
                                                                                color: Color(
                                                                                    0xff7e7e7e),
                                                                                fontSize: 11,
                                                                                fontFamily:
                                                                                    "LatoRegular",
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  child: SmoothStarRating(
                                                    allowHalfRating: false,
//                                      onRatingChanged: (v) {
//                                        rating = v;
//                                        setState(() {
//                                          print(rating);
//                                        });
//                                      },
                                                    starCount: 5,
                                                    rating: _filterModel?.doctor?.doctors[index]
                                                                ?.doctorFeedback[0].stars !=
                                                            null
                                                        ? (double.parse(_filterModel
                                                            ?.doctor
                                                            ?.doctors[index]
                                                            ?.doctorFeedback[0]
                                                            ?.stars))
                                                        : (0),
                                                    size: 13.0,
                                                    //filledIconData: Icons.blur_off,
                                                    // halfFilledIconData: Icons.blur_on,
                                                    color: starColor,
                                                    //borderColor: Colors.green,

                                                    spacing: 0.0,
                                                    defaultIconData: Icons.star,
                                                    borderColor: starDisableColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.convert(context, 4),
                                                ),
                                                Container(
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        text: availability == 0
                                                            ? "Available Today\nNext 3 Days"
                                                            : availability == 1
                                                                ? "Available Today"
                                                                : "Available Next 3 Days",
                                                        style: TextStyle(
                                                            fontFamily: "LatoRegular",
                                                            fontSize: 10,
                                                            color: buttonColor)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.convert(
                                                      context, size.convert(context, 38)),
                                                ),
                                                Container(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("pressed appointments button");
                                                      getIt<GlobalSingleton>()
                                                          .navigationKey
                                                          .currentState
                                                          .push(PageTransition(
                                                              child: selectAppointmentDate(
                                                                doctorModel: _filterModel
                                                                    ?.doctor?.doctors[index],
                                                              ),
                                                              type:
                                                                  PageTransitionType.leftToRight));
                                                    },
                                                    child: Container(
                                                      height: size.convert(context, 30),
                                                      width: size.convertWidth(context, 150),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(2),
                                                          color: buttonColor),
                                                      child: Center(
                                                        child: Text(
                                                          TranslationBase.of(context)
                                                              .bookAppointmentbuttontext,
                                                          style: TextStyle(
                                                            fontFamily: "LatoRegular",
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
        _searchShow(),
      ],
    );
  }

  _filterBody() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.convert(context, 16),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.convert(context, 35),
              vertical: size.convert(context, 18),
            ),
            decoration: BoxDecoration(color: portionColor.withOpacity(0.05)),
            child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      TranslationBase.of(context).availability,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoBold",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.convert(context, 20),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          availability = 0;
                        });
                      },
                      child: Container(
                          child: customCheckBox(
                        check: availability == 0,
                      )),
                    ),
                    SizedBox(
                      width: size.convert(context, 10),
                    ),
                    Text(
                      TranslationBase.of(context).availableAll,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.convert(context, 15),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          availability = 1;
                        });
                      },
                      child: Container(
                          child: customCheckBox(
                        check: availability == 1,
                      )),
                    ),
                    SizedBox(
                      width: size.convert(context, 10),
                    ),
                    Text(
                      TranslationBase.of(context).availableToday,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.convert(context, 15),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          availability = 2;
                        });
                      },
                      child: Container(
                          child: customCheckBox(
                        check: availability == 2,
                      )),
                    ),
                    SizedBox(
                      width: size.convert(context, 10),
                    ),
                    Text(
                      TranslationBase.of(context).availableNext3day,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 10),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.convert(context, 35),
              vertical: size.convert(context, 18),
            ),
            decoration: BoxDecoration(color: portionColor.withOpacity(0.05)),
            child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      TranslationBase.of(context).gender,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoBold",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.convert(context, 20),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = 0;
                        });
                      },
                      child: Container(
                          child: customCheckBox(
                        check: gender == 0,
                      )),
                    ),
                    SizedBox(
                      width: size.convert(context, 10),
                    ),
                    Text(
                      TranslationBase.of(context).bothGender,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.convert(context, 15),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = 2;
                        });
                      },
                      child: Container(
                          child: customCheckBox(
                        check: gender == 2,
                      )),
                    ),
                    SizedBox(
                      width: size.convert(context, 10),
                    ),
                    Text(
                      TranslationBase.of(context).male,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.convert(context, 15),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = 1;
                        });
                      },
                      child: Container(
                          child: customCheckBox(
                        check: gender == 1,
                      )),
                    ),
                    SizedBox(
                      width: size.convert(context, 10),
                    ),
                    Text(
                      TranslationBase.of(context).female,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 12),
                        fontFamily: "LatoRegular",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: size.convert(context, 16),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                useFilter = false;
                print("filter call");
              });

              _getDoctorList();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 24)),
              height: size.convert(context, 50),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(size.convert(context, 3)),
              ),
              child: Center(
                child: Text(
                  TranslationBase.of(context).apply,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.convert(context, 13),
                      fontFamily: "LatoRegular"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _searchShow() {
    Size sizem = MediaQuery.of(context).size;
    return _textEditingController.text.length < 3
        ? SizedBox()
        : Positioned(
            top: MediaQuery.of(context).size.longestSide * 0.21,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xffFFFFFF),
                  border: Border.all(color: Color(0xff707070), width: 0.2),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff7E7E7E).withOpacity(0.2), blurRadius: 5, spreadRadius: 2)
                  ]),
              width: MediaQuery.of(context).size.width - 40,
              constraints: BoxConstraints(maxHeight: sizem.height / 2, minHeight: 0),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: Colors.grey[300],
                    child: Text(
                      TranslationBase.of(context).doctor,
                      style: TextStyle(color: Colors.black, fontFamily: "LatoRegular"),
                    ),
                  ),
                  doctorSpecialitySearchModel.doctors.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            TranslationBase.of(context).noDoctorMatched,
                            style: TextStyle(
                              fontFamily: "LatoRegular",
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: doctorSpecialitySearchModel?.doctors?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateOnDoctorTap(doctorSpecialitySearchModel?.doctors[index]);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      doctorSpecialitySearchModel?.doctors[index].doctorName,
                                      style: TextStyle(
                                        fontFamily: "LatoRegular",
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
                              height: 1,
                              color: portionColor.withOpacity(0.1),
                              //color: Color(0xff7E7E7E),
                            );
                          },
                        ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: Colors.grey[300],
                    child: Text(
                      TranslationBase.of(context).speciality,
                      style: TextStyle(color: Colors.black, fontFamily: "LatoRegular"),
                    ),
                  ),
                  doctorSpecialitySearchModel.specialitys.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            TranslationBase.of(context).noSpecialityMatched,
                            style: TextStyle(
                              fontFamily: "LatoRegular",
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: doctorSpecialitySearchModel?.specialitys?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateOnSpecailityTap(
                                      doctorSpecialitySearchModel?.specialitys[index]);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      doctorSpecialitySearchModel
                                          ?.specialitys[index].specialityName,
                                      style: TextStyle(
                                        fontFamily: "LatoRegular",
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
                              height: 1,
                              color: portionColor.withOpacity(0.1),
                              //color: Color(0xff7E7E7E),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
  }

  void _navigateOnDoctorTap(DoctorModel model) {
    getIt<GlobalSingleton>().navigationKey.currentState.pop();
    getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
        child: doctorDetail(doctorId: model.doctorID),
        type: PageTransitionType.leftToRightWithFade));
  }

  void _navigateOnSpecailityTap(SpecialityModel model) {
    getIt<GlobalSingleton>().navigationKey.currentState.pop();

    getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
        type: PageTransitionType.bottomToTop,
        child: doctorList(
          districtName: widget.districtName,
          specialityModel: model,
        )));
  }
  // void _navigateOnClinicTap(int clinicId) {
  //   getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
  //       type: PageTransitionType.bottomToTop,
  //       child: doctorList(
  //         districtName: seletedDistricitId != -1
  //             ? _districts.firstWhere((district) => district.id == seletedDistricitId).districtName
  //             : null,
  //         clinicID: clinicId,
  //       )));
  // }
}
