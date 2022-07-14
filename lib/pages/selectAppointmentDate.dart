import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/appointment/appointment_detail_model.dart';
import 'package:doctor_app/model/appointment/appointment_model.dart';
import 'package:doctor_app/model/clinicModel.dart';
import 'package:doctor_app/model/doctor/availability_time_model.dart';
import 'package:doctor_app/model/doctor/doctor_model.dart';
import 'package:doctor_app/model/doctor/part_of_the_daY_model.dart';
import 'package:doctor_app/model/server_body_model/appointment.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/myAppointment.dart';
import 'package:doctor_app/pages/signIn.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/customCalender.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:intl/intl.dart';
import 'package:menu_button/menu_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';

import 'patientdetail.dart';

class selectAppointmentDate extends StatefulWidget {
  final DoctorModel doctorModel;

  // final String updateAppointmentId;
  // final String doctorId;
  final int updateAppointmentId;
  final int doctorId;
  final int selectClinicId;

  const selectAppointmentDate(
      {Key key, this.doctorModel, this.updateAppointmentId, this.doctorId, this.selectClinicId})
      : super(key: key);

  @override
  _selectAppointmentDateState createState() => _selectAppointmentDateState();
}

class _selectAppointmentDateState extends State<selectAppointmentDate> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  CalendarController _calendarController = CalendarController();

  DateTime currentDate = DateTime.now();
  String selectedClinicName = "";
  bool showcalendar = false;
  bool isAppointmentempty = true;
  List<ClinicModel> clinics;
  int selectedClinicId;
  // String selectedClinicId;
  String clinicAddress;

  List<String> _weeekDays = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  List<PartOfTheDay> _availabilityList;

  bool loading = true;

  DoctorModel doctorModel;

  AppointmentDetailModel appointmentDetailModel;

  @override
  void initState() {
    // TODO: implement initState
    doctorModel = widget.doctorModel;
    super.initState();
//    getMySavedClinics(doctorId: doctorModel.doctorID);
    if (widget.updateAppointmentId != null)
      _getAppointmentDetails();
    else
      getMySavedClinics(doctorId: doctorModel.doctorID);
  }

  void getMySavedClinics({int doctorId, int clinicId, bool callFromUpdate = false}) async {
    if (clinicId != null) {
      _getDoctorAvailablity(clinicId: clinicId);
    } else {
      var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
          .get(url: GET_DOCTOR_SAVED_CLINIC_URL + doctorId.toString());

      if (response == NO_CONNECTION) {
        CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getMySavedClinics);
        return;
      }

      if (response is Response) {
        clinics = [];
        if (response.statusCode >= 200 && response.statusCode <= 202) {
          setState(() {
            response.data.forEach((json) => clinics.add(ClinicModel.fromJson(json)));
            clinics.removeWhere((test) =>
                double.parse(test.from.replaceAll(":", "")) == 0 &&
                double.parse(test.to.replaceAll(":", "")) == 0);
            if (callFromUpdate) {
              selectedClinicId = appointmentDetailModel?.clinicAddressId;
              selectedClinicName = clinics.firstWhere((f) => f.clinicId == selectedClinicId).name;
            } else {
              print("clinic NO = ${clinics.length}");
              selectedClinicId = clinics[0].clinicId;
              selectedClinicName = clinics[0].name;
              clinicAddress = clinics[0].address;
            }
            if (callFromUpdate) {
              _getDoctorAvailablity(
                  calledFromUpdate: true, clinicId: appointmentDetailModel?.clinicAddressId);
            } else {
              _getDoctorAvailablity(clinicId: selectedClinicId);
            }
          });
        }
      }

      if (mounted) setState(() {});
    }
  }

  _getAppointmentDetails() async {
    print("'appointment_id': ${widget.updateAppointmentId}");
    var response = await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey)
        .post(url: GET_APPOINTMENT_URL, body: {'appointment_id': widget.updateAppointmentId});

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: _getDoctorAvailablity);
      return;
    }

    if (response is Response) {
      print(response.data);
      appointmentDetailModel = AppointmentDetailModel.fromJson(response.data['appointment'][0]);
      _getDoctorModel();
    }
  }

  _getDoctorModel() async {
    var response =
        await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey).get(
      url: DOCTOR_INFO_URL + appointmentDetailModel.doctorId.toString(),
    );

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: _getDoctorModel);
      return;
    }

    if (response is Response) {
      doctorModel = DoctorModel.fromJson(response.data['Doctors'][0]);
      getMySavedClinics(
        doctorId: doctorModel.doctorID,
        callFromUpdate: true,
      );
    }
  }

  _getDoctorAvailablity({bool calledFromUpdate = false, int clinicId}) async {
    print(currentDate.toString().substring(0, 10));
    print("Doctor Id ${doctorModel.doctorID}");
    // print("clinic Id ${clinicId}");
    Map body;
    if (calledFromUpdate) {
      currentDate = DateTime.parse(appointmentDetailModel.appointmentDate);
      _calendarController.setSelectedDay(currentDate);
//      getMySavedClinics(callFromUpdate: true,doctorId: appointmentDetailModel.doctorId);
    }

    if (clinicId != null) {
      body = {
        "dayselected": _weeekDays[currentDate.weekday],
        "date": currentDate.toString().substring(0, 10),
        "doctor_id": doctorModel.doctorID,
        "clinic_id": clinicId
      };
    } else {
      body = {
        "dayselected": _weeekDays[currentDate.weekday],
        "date": currentDate.toString().substring(0, 10),
        "doctor_id": doctorModel.doctorID
      };
    }

    print("--------------------------");
    print(body);
    print("--------------------------");
    setState(() {
      loading = true;
      _availabilityList = null;
    });

    var response = await API(showSnackbarForError: true, scaffold: _scaffoldkey, context: context)
        .post(url: BOOK_APPOINTMENT_DOCTOR_AVAILABILITY_URL, body: body);
    _availabilityList = [];
    setState(() {
      loading = false;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: _getDoctorAvailablity);
      return;
    }

    if (response is Response) {
      if (response.data is Map) {
        Map json = response.data;

        List<AppointmentModel> appointments = [];

        if (json.containsKey('appointment')) {
          if (json['appointment'] is List) {
            if (json['appointment'].length > 0) {
              setState(() {
                isAppointmentempty = false;
              });
            }
            json['appointment'].forEach((appJson) {
              ///dont add the appointment which is going to be updated
              AppointmentModel appModel = AppointmentModel.fromJson(appJson);
              if (appModel.appID != widget.updateAppointmentId) appointments.add(appModel);
            });
          }
        }

        if (json.containsKey('visit_time')) {
          if (json['visit_time'] is List) {
            json['visit_time'].forEach((visitJson) {
              AvailabilityTimeModel time = AvailabilityTimeModel.fromJson(visitJson);
              List<String> timeSplit = time.visitTime.split(':');

//              currentDate.toString().substring(0, 10) ==
//                  DateTime.now().toString().substring(0, 10)

              DateTime timeForVisit = DateTime(currentDate.year, currentDate.month, currentDate.day,
                  int.parse(timeSplit[0]), int.parse(timeSplit[1]), int.parse(timeSplit[2]));

              if (widget.updateAppointmentId != null) {
                ///select the time if matches with the appointment time
                DateTime appointmentDate = DateTime.parse(appointmentDetailModel.appointmentDate);

                if (currentDate.toString().substring(0, 10) ==
                        appointmentDate.toString().substring(0, 10) &&
                    time.visitTime == appointmentDetailModel.appointmentTime) {
                  time.selected = true;
                }
              }

              if (appointments.firstWhere(
                          (appointment) => appointment.appointmentTime == time.visitTime,
                          orElse: () => null) ==
                      null &&
                  timeForVisit.compareTo(DateTime.now()) > 0) {
                ///
                ///
                ///No appointment found at this time
                ///
                ///

                if (int.parse(timeSplit[0]) >= 5 && int.parse(timeSplit[0]) < 12) {
                  ///Morning
                  if (_availabilityList.firstWhere((time) => time.dayName == "Morning",
                          orElse: () => null) !=
                      null) {
                    _availabilityList
                        .firstWhere((time) => time.dayName == "Morning")
                        .timeSlots
                        .add(time);
                  } else {
                    PartOfTheDay partOfTheDay = PartOfTheDay()
                      ..timeSlots.add(time)
                      ..dayName = "Morning";
                    _availabilityList.add(partOfTheDay);
                  }
                } else if (int.parse(timeSplit[0]) >= 12 && int.parse(timeSplit[0]) < 17) {
                  ///AfterNoon
                  if (_availabilityList.firstWhere((time) => time.dayName == "Afternoon",
                          orElse: () => null) !=
                      null) {
                    _availabilityList
                        .firstWhere((time) => time.dayName == "Afternoon")
                        .timeSlots
                        .add(time);
                  } else {
                    PartOfTheDay partOfTheDay = PartOfTheDay()
                      ..timeSlots.add(time)
                      ..dayName = "Afternoon";
                    _availabilityList.add(partOfTheDay);
                  }
                } else if (int.parse(timeSplit[0]) >= 17 && int.parse(timeSplit[0]) < 21) {
                  ///Evening
                  if (_availabilityList.firstWhere((time) => time.dayName == "Evening",
                          orElse: () => null) !=
                      null) {
                    _availabilityList
                        .firstWhere((time) => time.dayName == "Evening")
                        .timeSlots
                        .add(time);
                  } else {
                    PartOfTheDay partOfTheDay = PartOfTheDay()
                      ..timeSlots.add(time)
                      ..dayName = "Evening";
                    _availabilityList.add(partOfTheDay);
                  }
                } else if (int.parse(timeSplit[0]) >= 21) {
                  ///Night
                  if (_availabilityList.firstWhere((time) => time.dayName == "Night",
                          orElse: () => null) !=
                      null) {
                    _availabilityList
                        .firstWhere((time) => time.dayName == "Night")
                        .timeSlots
                        .add(time);
                  } else {
                    PartOfTheDay partOfTheDay = PartOfTheDay()
                      ..timeSlots.add(time)
                      ..dayName = "Night";
                    _availabilityList.add(partOfTheDay);
                  }
                }
              }
            });
          }
        }
      }
    }
    setState(() {});
  }

  Widget dropDownWidget() {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: size.convert(context, 35)),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.convert(context, 150),
                  height: size.convert(context, 30),
                  child: MenuButton(
                    inContainerHeight: dropDownHeight(),
                    outContainerHeight: dropDownHeight(),
                    topDivider: false,
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: size.convert(context, 150),
                      height: size.convert(context, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: selectedClinicName,
                                    style: TextStyle(
                                        fontSize: size.convert(context, 14),
                                        fontFamily: "LatoBold",
                                        color: buttonColor)),
                              ),
                            ),
                          ),
                          Container(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: buttonColor,
                              size: size.convert(context, 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    items: clinics ?? [],
                    itemBuilder: (clinic) {
                      if (clinic is ClinicModel) {
                        print("${clinic.name}");
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: size.convert(context, 30),
                          width: size.convert(context, 150),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: clinic.name,
                                        style: TextStyle(
                                            fontSize: size.convert(context, 14),
                                            fontFamily: "LatoBold",
                                            color: buttonColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else
                        return Container();
                    },
                    decoration: BoxDecoration(
                        border: Border.all(color: buttonColor),
                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.white),
                    divider: Container(
                      height: 0.4,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    onItemSelected: (clinic) {
                      if (clinic is ClinicModel) {
                        setState(() {
                          selectedClinicName = clinic.name;
                          selectedClinicId = clinic.clinicId;
                          clinicAddress = clinic.address;
                        });
                        _getDoctorAvailablity(clinicId: selectedClinicId);
                      }
                      // Action when new item is selected
                    },
                    toggledChild: Container(),

//                    Container(
//                      color: Colors.transparent,
//                      padding: EdgeInsets.symmetric(horizontal: 8),
//                      width: size.convert(context, 150),
//                      height: size.convert(context, 30),
//                      child: Row(
//                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Expanded(
//                            child: Container(
//                              child: RichText(
//                                maxLines: 1,
//                                text: TextSpan(
//                                    text: "",
//                                    style: TextStyle(
//                                        fontSize: size.convert(context, 14),
//                                        fontFamily: "LatoBold",
//                                        color: buttonColor)),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  double dropDownHeight() {
    if (clinics != null) {
      if (clinics.length > 5) {
        return 150;
      } else {
        print("greater then 5");
        print("${(clinics.length + 1) * 30.1}");
        return (clinics.length) * 30.0;
      }
    } else {
      return 0.1;
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
      ),
    );
  }

  _leading() {
    return Container(
      child: GestureDetector(
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
            text: TranslationBase.of(context).selectatimeslot,
            style: TextStyle(fontSize: 14, fontFamily: "LatoRegular", color: appBarIconColor)),
      ),
    );
  }

  _trailing() {
    return Container(
      child: InkWell(
        onTap: detailPad,
        child: Transform.rotate(
          angle: 180 * math.pi / 165,
          child: Icon(
            IcoFontIcons.uiCall,
            color: appBarIconColor,
          ),
        ),
//        child: Image.asset("assets/icons/phone.png",
//        color: appBarIconColor,),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.convert(context, 2)),
        child: Column(
          children: <Widget>[
            Container(
              child: CustomCalendar(
                calendarController: _calendarController,
                startDate: DateTime.now(),
                initalDatTime: currentDate,
                showAll: showcalendar,
                onDaySelected: _dayselected,
              ),
            ),
            _doctorDetail(),
            _doctorTimeSelect(),
          ],
        ),
      ),
    );
  }

  _doctorDetail() {
    DoctorModel doctor = this.doctorModel;
    if (doctor == null)
      return Center(
        child: Loading(),
      );

    return Container(
        margin: EdgeInsets.symmetric(horizontal: size.convert(context, 26)),
        padding: EdgeInsets.only(top: size.convert(context, 28)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: circularImage(
                imageUrl: DOCTOR_IMAGE_URL + (doctor?.doctorPicture ?? ""),
                w: size.convert(context, 62),
                h: size.convert(context, 62),
              ),
            ),
            SizedBox(
              width: size.convert(context, 5),
            ),
            Expanded(
              child: Container(
                //color: Colors.deepOrange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: RichText(
                                maxLines: 2,
                                text: TextSpan(
                                    text: (doctor?.title ?? "") +
                                        " " +
                                        (doctor?.doctorName ?? "") +
                                        " " +
                                        (doctor?.doctorLastName ?? ""),
                                    style: TextStyle(
                                        color: buttonColor,
                                        fontFamily: "LatoRegular",
                                        fontSize: size.convert(context, 14))),
                              ),
                            ),
                          ),
                          Container(
                            //color: Colors.red,
                            width: 100,
                            child: RichText(
                              text: TextSpan(
                                  text:
                                      "${DateTime(currentDate.year, currentDate.month, currentDate.day).compareTo(
                                                DateTime(DateTime.now().year, DateTime.now().month,
                                                    DateTime.now().day),
                                              ) == 0 ? "${TranslationBase.of(context).today}, " : ""}" +
                                          DateFormat.d().format(currentDate) +
                                          " " +
                                          DateFormat.MMM().format(currentDate),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.convert(context, 14),
                                      fontFamily: "LatoBold")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: RichText(
                        maxLines: 1,
                        text: TextSpan(
                            text: doctor?.expert ?? "",
                            style: TextStyle(
                                color: portionColor,
                                fontFamily: "LatoRegular",
                                fontSize: size.convert(context, 10))),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/Map_1614.png",
                            width: size.convert(context, 8),
                            height: size.convert(context, 12),
                          ),
//                         SvgPicture.asset(
//                          "assets/icons/mapMark.svg",
//                          height: size.convert(context, 40),
//                          width: size.convert(context, 40),
//                        ),
                          SizedBox(
                            width: size.convert(context, 5),
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                                text: clinicAddress ?? "",
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
                            text: (doctor?.doctorFee == 0 || doctor?.doctorFee == null)
                                ? "${TranslationBase.of(context).fee}:  ${TranslationBase.of(context).free}"
                                : "${TranslationBase.of(context).fee}: ${doctor?.doctorFee ?? ""} ${TranslationBase.of(context).currencySymbol ?? ""}",
                            // " ${TranslationBase.of(context).currencySymbol ?? ""} ${doctor?.doctorFee ?? ""}",
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
            )
          ],
        ));
  }

  _dayselected(DateTime day, List events) {
    print(day);
    setState(() {
      currentDate = day;
    });
    getMySavedClinics(doctorId: doctorModel.doctorID, clinicId: selectedClinicId);
    //  _getDoctorAvailablity();
  }

  _doctorTimeSelect() {
    return _availabilityList == null
        ? Center(
            child: Loading(),
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
////                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: <Widget>[
//                       Container(
//                          child: RichText(
//                            text: TextSpan(
//                                text:
//                                    "${DateTime(currentDate.year, currentDate.month, currentDate.day).compareTo(
//                                              DateTime(
//                                                  DateTime.now().year,
//                                                  DateTime.now().month,
//                                                  DateTime.now().day),
//                                            ) == 0 ? "Today, " : ""}" +
//                                        DateFormat.d().format(currentDate) +
//                                        " " +
//                                        DateFormat.MMM().format(currentDate),
//                                style: TextStyle(
//                                    color: Colors.black,
//                                    fontSize: size.convert(context, 14),
//                                    fontFamily: "LatoBold")),
//                          ),
//                        ),
//
//                     ],
//                   ),
//                 ),

                SizedBox(
                  height: size.convert(context, 5),
                ),
//                Container(
//                  margin: EdgeInsets.symmetric(horizontal: 15),
//                  child:   Wrap(
//                    runSpacing: 10,
//                  spacing: 10,
//                  children: clinics.map((clinic)=>GestureDetector(
//                    onTap: (){
//                      setState(() {
//                        selectedClinicName = clinic.name;
//                        selectedClinicId = clinic.clinicId;
//                        clinicAddress = clinic.address;
//                      });
//                      _getDoctorAvailablity(clinicId: selectedClinicId);
//                    },
//                    child: Container(
//                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
//                      decoration: BoxDecoration(
//                          color: selectedClinicId == clinic.clinicId ? buttonColor.withOpacity(0.5) : Colors.white,
//                          border: Border.all(
//                            color: buttonColor,
//                            width: 1,
//                          ),
//                          borderRadius: BorderRadius.circular(5)
//                      ),
//                      child: Column(
//                        children: <Widget>[
//                          Text("Clinic name : ${clinic.name}"),
//                          SizedBox(height: 5,),
//                          Text("${clinic.address} ",
//                            style: TextStyle(),)
//                        ],
//                      ),
//                    ),
//                  )).toList().cast<Widget>(),
//                ),),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.convert(context, 15)),
                  //color: Colors.red,
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: clinics?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedClinicName = clinics[index].name;
                            selectedClinicId = clinics[index].clinicId;
                            clinicAddress = clinics[index].address;
                          });
                          _getDoctorAvailablity(clinicId: selectedClinicId);
                        },
                        child: Container(
                          height: size.convert(context, 60),
                          //padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          decoration: BoxDecoration(
                              color: selectedClinicId == clinics[index].clinicId
                                  ? buttonColor.withOpacity(0.5)
                                  : Colors.white,
                              border: Border.all(
                                color: buttonColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                text: TextSpan(
                                    text: " ${clinics[index].name}",
                                    style: TextStyle(color: Colors.black)),
                              ),
//                            Text(
//                                " ${clinics[index].name} asdfasdf s fasdf sdf asf sf asf asdfsf as  s"),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
//                                "${clinics[index].address}(${clinics[index].from.substring(0,5)}-${clinics[index].to.substring(0,5)}) ",
                                "(${clinics[index].from.substring(0, 5)}-${clinics[index].to.substring(0, 5)}) ",
                                style: TextStyle(),
                              ),
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                              Expanded(child: Text(" ${clinics[index].name}"),)
//                            ],),
//                            SizedBox(height: 5,),
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              //crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
////                                Image.asset("assets/icons/Map_1614.png",
////                                  height: size.convert(context, 12),),
////                                SizedBox(width: 5,),
//                              Expanded(child: Text(
////                                "${clinics[index].address}(${clinics[index].from.substring(0,5)}-${clinics[index].to.substring(0,5)}) ",
//                                "(${clinics[index].from.substring(0,5)}-${clinics[index].to.substring(0,5)}) ",
//                                style: TextStyle(),),)
//                            ],),
                            ],
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                ),
                SizedBox(
                  height: size.convert(context, 22),
                ),
                _slotsView(),
                SizedBox(
                  height: size.convert(context, 62),
                ),
              ],
            ),
          );
  }

  _slotsView() {
    return (_availabilityList?.length ?? 0) == 0
        ? isAppointmentempty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    TranslationBase.of(context).noTimeSlotAvailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 15),
                        fontFamily: "LatoBold"),
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    TranslationBase.of(context).allSlotBooked,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 15),
                        fontFamily: "LatoBold"),
                  ),
                ),
              )
        : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: _availabilityList?.length ?? 0,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.convert(context, 30)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset(
                          selectIcons(_availabilityList[index].dayName),
                          height: size.convert(context, 16),
                          width: size.convert(context, 18),
                          color: buttonColor,
                        ),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: Text(selectDay(_availabilityList[index].dayName),
                            style: TextStyle(
                              fontSize: size.convert(context, 12),
                              color: Colors.black,
                              fontFamily: "LatoBold",
                            )),
                      ),
                      SizedBox(
                        width: size.convert(context, 8),
                      ),
                      Container(
                        child: Text(
                          "${_availabilityList[index].timeSlots.length} ${TranslationBase.of(context).slots}",
                          style: TextStyle(
                            fontSize: size.convert(context, 12),
                            color: portionColor,
                            fontFamily: "LatoRegular",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.convert(context, 20),
                ),
                _listOfTimeSlots(index),
                SizedBox(
                  height: size.convert(context, 20),
                ),
              ],
            ),
          );
  }

  String selectIcons(String name) {
    if (name == "Morning") return "assets/icons/morning.svg";
    if (name == "Afternoon") return "assets/icons/afternoon.svg";
    if (name == "Evening") return "assets/icons/morning.svg";
    if (name == "Night")
      return "assets/icons/morning.svg";
    else
      return "null";
  }

  String selectDay(String name) {
    if (name == "Morning") return TranslationBase.of(context).morning;
    if (name == "Afternoon") return TranslationBase.of(context).afternoon;
    if (name == "Evening") return TranslationBase.of(context).evening;
    if (name == "Night")
      return TranslationBase.of(context).night;
    else
      return "null";
  }

  _listOfTimeSlots(int parientIndex) {
    Size sizeQ = MediaQuery.of(context).size;
    return SizedBox(
      height: size.convert(context, 50),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: _availabilityList[parientIndex].timeSlots.length,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            _availabilityList.forEach((slot) {
              slot.timeSlots.forEach((time) => time.selected = false);
            });
            _availabilityList[parientIndex].timeSlots[index].selected = true;
            setState(() {});
          },
          child: Container(
            height: size.convert(context, 40),
            width: size.convert(context, 82),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.convert(context, 5)),
              border: Border.all(
                color: buttonColor,
                width: size.convert(context, 1),
              ),
              color: _availabilityList[parientIndex].timeSlots[index].selected
                  ? buttonColor.withOpacity(0.4)
                  : Colors.transparent,
            ),
            child: Center(
                child: Text(
              _availabilityList[parientIndex].timeSlots[index].visitTime,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "LatoRegular",
                fontSize: size.convert(context, 12),
              ),
            )),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          width: size.convert(context, 10),
        ),
      ),
    );
  }

  _button() {
    return Container(
      margin: EdgeInsets.only(bottom: size.convert(context, 20)),
      child: GestureDetector(
        onTap: _bookAppointment,
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

  _bookAppointment() async {
    PartOfTheDay condition = _availabilityList.firstWhere(
        (dayTime) =>
            dayTime.timeSlots.firstWhere((time) => time.selected, orElse: () => null)?.selected ??
            false,
        orElse: () => null);

    if (condition == null) {
      CustomSnackBar.SnackBar_3Error(_scaffoldkey,
          title: TranslationBase.of(context)?.pleaseSelectTime ?? "",
          leadingIcon: Icons.error_outline);
      return;
    }

    CreateAppointment appointment = CreateAppointment(
        date: DateFormat("yyyy/MM/dd").format(currentDate),
        time: condition.timeSlots.firstWhere((dayTime) => dayTime.selected).visitTime,
        doctor: doctorModel,
        appointmentDetailModel: appointmentDetailModel);

//    print(appointment.toJson());
    // String temp1 = ;
    // int userIdVal = int.parse(temp1);

    if (await UserModel.getUserId == null) {
      ///Signin or signup user
      ///once user authenticated select for whom the appointment is being booked
      ///Self or Family
      getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
          type: PageTransitionType.rightToLeft,
          child: signIn(
            clinicAdress: clinicAddress ?? "",
            clinicId: selectedClinicId ?? "",
            appointment: appointment ?? "",
          )));
    } else {
      ///Take to selection screen to select Self or family

      getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
          type: PageTransitionType.rightToLeft,
          child: patientDetail(
            clinicAdress: clinicAddress ?? "",
            clinicId: selectedClinicId ?? "",
            appointment: appointment ?? "",
          )));
    }
  }
}
