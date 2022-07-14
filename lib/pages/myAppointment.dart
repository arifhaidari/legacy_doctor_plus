import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/pages/chat/chat.dart';
import 'package:doctor_app/pages/selectAppointmentDate.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/model/appointment/appointment_model.dart';
import 'package:doctor_app/model/appointment/appointment_model_list.dart';
import 'package:doctor_app/model/family/family_profile_list.dart';
import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/repeatedWidgets/CustomBottomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/CustomDrawer.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/repeatedWidgets/notificationIcon.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:intl/intl.dart';
import 'package:menu_button/menu_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/string.dart';
import 'package:provider/provider.dart';

class myAppointment extends StatefulWidget {
  bool pref;
  myAppointment({this.pref = true});
  @override
  _myAppointmentState createState() => _myAppointmentState();
}

class _myAppointmentState extends State<myAppointment> {
  //int select = 2;

  FamilyListModel familyListModel;

  AppointmentModelList appointmentModelList = new AppointmentModelList();
  AppointmentModelList appointmentModelCategory = new AppointmentModelList();

  int selectedUserId;
  // String selectedUserId;
  String selectedUserName;
  int categoryTypeId = 7;
  int userId;
  // String userId;
  bool familyLoader = false;

  /// for all type appointments
  String categoryTypeName;
  List<ChateMessageNotification> newMessageArriveFrom = [];

  List<String> weekDays = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    selectedUserId = -2;

//    selectedUserName = "";

    getAllAppointments(widget.pref);
  }

  _getFamilyData({var data, bool pref = false}) async {
    if (pref) {
      familyListModel = await FamilyListModel.getFamilyProfile();
      familyListModel.familiesModel.insert(0, FamilyProfileModel(patientID: -1, pName: "Self"));

      familyListModel.familiesModel.insert(0, FamilyProfileModel(patientID: -2, pName: "All"));
    } else {
      familyListModel = FamilyListModel.fromJson(data);
      await FamilyListModel.saveFamilyProfile(data);
      familyListModel.familiesModel.insert(0, FamilyProfileModel(patientID: -1, pName: "Self"));

      familyListModel.familiesModel.insert(0, FamilyProfileModel(patientID: -2, pName: "All"));
    }
    setState(() {});
  }

  _getUserAppointment({bool loadPrefs = true}) async {
    setState(() {
      familyLoader = true;
    });
    String nowDate = DateTime.now().toString().substring(0, 10).replaceAll("-", "");
    String nowTime = DateTime.now().toString().substring(11, 19).replaceAll(":", "");
    print("SELECTED USER ID $selectedUserId");
    if (loadPrefs && selectedUserId == -2) {
      print("Get all appointments******AAA**");
      getAllAppointments(true);
      return;
    }

    ///--- For Offline
    else if (!loadPrefs) {
      int lastPage = 1;
      Map body = {};
      if (selectedUserId == -1) {
        String temp1 = await UserModel.getUserId;
        int userID = int.parse(temp1);
        body = {'user_id': userID};
      } else {
        body = {'family_member_id': selectedUserId};
      }
      print(body);
      for (int currentPage = 1; currentPage <= lastPage; currentPage++) {
        var response =
            await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey).post(
                url: selectedUserId == -1
                    ? MY_APPOINTMENT_LIST_URL + "?page=${currentPage.toString()}"
                    : FAMILY_APPOINTMENT_LIST_URL + "?page=${currentPage.toString()}",
                body: body);

        if (response == NO_CONNECTION) {
          CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getAllAppointments);
          return;
        }
//    {"typeId": 7,"typeName":TranslationBase.of(context).all},
//    {"typeId": 0,"typeName":TranslationBase.of(context).upcoming},
//    {"typeId": 1,"typeName":TranslationBase.of(context).current},
//    {"typeId": 2,"typeName":TranslationBase.of(context).cancel},
//    {"typeId": 3,"typeName":TranslationBase.of(context).expire},

        if (response is Response) {
          appointmentModelList = AppointmentModelList.fromJson(response.data);
          appointmentModelCategory = AppointmentModelList.fromJson(response.data);
          appointmentModelCategory.appointments = [];
          appointmentModelList.appointments.forEach((test) {
            //current appointments
            if (test.Status == 0 &&
                int.parse((test.appointmentDate).replaceAll("-", "")) == int.parse(nowDate) &&
                int.parse(nowTime) < int.parse((test.appointmentTime).replaceAll(":", ""))) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          appointmentModelList.appointments.forEach((test) {
            //upcoming appointments
            if (test.Status == 0 &&
                int.parse((test.appointmentDate).replaceAll("-", "")) > int.parse(nowDate)) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          appointmentModelList.appointments.forEach((test) {
            //cancel appointments
            if (test.Status == 1 &&
                int.parse((test.appointmentDate).replaceAll("-", "")) >= int.parse(nowDate)) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          appointmentModelList.appointments.forEach((test) {
            //expire appointments
            if (((test.Status == 0 || test.Status == 1) &&
                    int.parse((test.appointmentDate).replaceAll("-", "")) < int.parse(nowDate)) ||
                (int.parse((test.appointmentDate).replaceAll("-", "")) == int.parse(nowDate) &&
                    int.parse(nowTime) > int.parse((test.appointmentTime).replaceAll(":", "")) &&
                    !(test.Status == 1))) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          lastPage = appointmentModelList.lastPage;
        }
        if (selectedUserId == -1) {
          AppointmentModelList.saveSelfAppointment(appointmentModelCategory.toJson());
        } else {
          AppointmentModelList.saveFamilyAppointment(
              selectedUserId, appointmentModelCategory.toJson());
        }
        if (appointmentModelList != null) _bothfilter();

        appointmentModelCategory.appointments.forEach((f) {
          print("patient name = ${f.pname} , user name = ${f.userName}");
        });
      }
      setState(() {
        familyLoader = false;
      });
      return;
    } else {
      appointmentModelList.appointments = [];
      appointmentModelCategory.appointments = [];
      AppointmentModelList appointmentList = await AppointmentModelList.getAllAppointments();

      if (selectedUserId == -1) {
        appointmentList.appointments.forEach((appointment) {
          if (appointment.patiendId == 0 || appointment.patiendId == -1) {
            appointmentModelList.appointments.add(appointment);
            appointmentModelCategory.appointments.add(appointment);
          }
        });
      } else {
        appointmentList.appointments.forEach((appointment) {
          if (appointment.patiendId == selectedUserId) {
            appointmentModelList.appointments.add(appointment);
            appointmentModelCategory.appointments.add(appointment);
          }
        });
      }
      if (appointmentModelList != null) _bothfilter();
      setState(() {
        familyLoader = false;
      });
      return;

//      if (selectedUserId == "-1") {
//        appointmentModelList = await (AppointmentModelList.getSelfAppointments());
//        appointmentModelCategory =
//        await (AppointmentModelList.getSelfAppointments());
//        if (appointmentModelList != null) _bothfilter();
//      } else {
//        appointmentModelList =
//        await (AppointmentModelList.getFamilyAppointments(selectedUserId));
//        appointmentModelCategory =
//        await (AppointmentModelList.getFamilyAppointments(selectedUserId));
//        if (appointmentModelList != null) _bothfilter();
//      }

    }

    setState(() {
      familyLoader = false;
    });

    ///--- For Online
  }

  _bothfilter() async {
    print("call both filter..............");
    String nowDate = DateTime.now().toString().substring(0, 10).replaceAll("-", "");
    String nowTime = DateTime.now().toString().substring(11, 19).replaceAll(":", "");
    if (categoryTypeId == 0) {
      print("this is upcoming appointments");
      if (appointmentModelCategory != null) appointmentModelCategory.appointments = [];
      appointmentModelList?.appointments?.forEach((test) {
        if (test.Status == 0 &&
            double.parse((test.appointmentDate).replaceAll("-", "")) > double.parse(nowDate)) {
          print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
          print("now data = ${int.parse(nowDate)}");
          appointmentModelCategory.appointments.add(test);
        }
        setState(() {});
      });
    } else if (categoryTypeId == 1) {
      print("this is current appointments");
      if (appointmentModelCategory != null) appointmentModelCategory.appointments = [];
      appointmentModelList?.appointments?.forEach((test) {
        double appointmentTime = double.parse(test.appointmentTime.replaceAll(":", ""));
        if (test.Status == 0 &&
            double.parse((test.appointmentDate).replaceAll("-", "")) == double.parse(nowDate) &&
            double.parse(nowTime) < appointmentTime) {
          print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
          print("now data = ${int.parse(nowDate)}");
          appointmentModelCategory.appointments.add(test);
        }
        setState(() {});
      });
    } else if (categoryTypeId == 2) {
      print("this is cancel appointments");
      if (appointmentModelCategory != null) appointmentModelCategory.appointments = [];
      appointmentModelList?.appointments?.forEach((test) {
        if (test.Status == 1 &&
            double.parse((test.appointmentDate).replaceAll("-", "")) >= double.parse(nowDate)) {
          print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
          print("now data = ${int.parse(nowDate)}");
          appointmentModelCategory.appointments.add(test);
        }
        setState(() {});
      });
    } else if (categoryTypeId == 3) {
      print("this is expire appointments");
      if (appointmentModelCategory != null) appointmentModelCategory.appointments = [];
      appointmentModelList?.appointments?.forEach((test) {
        double appointmentTime = double.parse(test.appointmentTime.replaceAll(":", ""));
        if (((test.Status == 0 || test.Status == 1) &&
                double.parse((test.appointmentDate).replaceAll("-", "")) < double.parse(nowDate)) ||
            (double.parse((test.appointmentDate).replaceAll("-", "")) == double.parse(nowDate) &&
                double.parse(nowTime) > appointmentTime &&
                !(test.Status == 1))) {
          print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
          print("now data = ${int.parse(nowDate)}");
          appointmentModelCategory.appointments.add(test);
        }
        setState(() {});
      });
    } else if (categoryTypeId == 7) {
      print("all all all all all ");
      if (appointmentModelCategory != null) appointmentModelCategory.appointments = [];
      String nowDate = DateTime.now().toString().substring(0, 10).replaceAll("-", "");
      String nowTime = DateTime.now().toString().substring(11, 19).replaceAll(":", "");
      //appointmentModelCategory.appointments = [];
      appointmentModelList.appointments.forEach((test) {
        //current appointments
        if (test.Status == 0 &&
            int.parse((test.appointmentDate).replaceAll("-", "")) == int.parse(nowDate) &&
            int.parse(nowTime) < int.parse((test.appointmentTime).replaceAll(":", ""))) {
          appointmentModelCategory.appointments.add(test);
        }
      });
      appointmentModelList.appointments.forEach((test) {
        //upcoming appointments
        if (test.Status == 0 &&
            int.parse((test.appointmentDate).replaceAll("-", "")) > int.parse(nowDate)) {
          appointmentModelCategory.appointments.add(test);
        }
      });
      appointmentModelList.appointments.forEach((test) {
        //cancel appointments
        if (test.Status == 1 &&
            int.parse((test.appointmentDate).replaceAll("-", "")) >= int.parse(nowDate)) {
          appointmentModelCategory.appointments.add(test);
        }
      });
      appointmentModelList.appointments.forEach((test) {
        //expire appointments
        if (((test.Status == 0 || test.Status == 1) &&
                int.parse((test.appointmentDate).replaceAll("-", "")) < int.parse(nowDate)) ||
            (int.parse((test.appointmentDate).replaceAll("-", "")) == int.parse(nowDate) &&
                int.parse(nowTime) > int.parse((test.appointmentTime).replaceAll(":", "")) &&
                !(test.Status == 1))) {
          appointmentModelCategory.appointments.add(test);
        }
      });
//      if(selectedUserId =="-2") appointmentModelCategory = await AppointmentModelList.getAllAppointments();
//      else if(selectedUserId =="-1") appointmentModelCategory = await AppointmentModelList.getSelfAppointments();
//      else appointmentModelCategory = await AppointmentModelList.getFamilyAppointments(selectedUserId);
      setState(() {});
    }
    print(
        "length of appointmentModelCategory = ${appointmentModelCategory?.appointments?.length ?? 0}");
    print("length of appointmentModelList = ${appointmentModelList?.appointments?.length ?? 0}");
  }

  getAllAppointments(bool loadPrefs) async {
    setState(() {
      familyLoader = true;
    });
    int lastPage = 1;

    ///For Offline
    if (loadPrefs && (await AppointmentModelList.getAllAppointments()) != null && 2 == 1) {
      // appointmentModelList = await AppointmentModelList.getAllAppointments();
      // appointmentModelCategory = await AppointmentModelList.getAllAppointments();
      // _getFamilyData(pref: true);
      // if (appointmentModelList != null) {
      //   appointmentModelList.appointments
      //       .sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      //   appointmentModelCategory.appointments
      //       .sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      // }

      // _bothfilter();
    } else {
      String userId = await UserModel.getUserId;
      // int userId = int.parse(temp0);
      // print("user id = ${userId}");
      int index = 1;
      for (int _currentPage = 1; _currentPage <= lastPage; _currentPage++) {
        var response =
            await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey)
                .post(url: ALL_APPOINTMENT_LIST_URL + "?page=${_currentPage.toString()}", body: {
          'user_id': userId.toString(),
        });

        if (response == NO_CONNECTION) {
          CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: getAllAppointments);
          return;
        }

        if (response is Response) {
          print("///////////////////Appointments list start /////////////////////////");
          print(response.data);
          print("///////////////////Appointments list end /////////////////////////");

          AppointmentModelList userApp =
              AppointmentModelList.fromJson(response.data['user_appointment']);
          AppointmentModelList familyApp =
              AppointmentModelList.fromJson(response.data['family_appointment']);
          if (index == 1) {
            index = 2;
            print("${index}");
            _getFamilyData(data: response.data);
            if (appointmentModelList != null || appointmentModelList?.appointments?.length != 0)
              appointmentModelList?.appointments = [];
            if (appointmentModelCategory != null ||
                appointmentModelCategory?.appointments?.length != 0)
              appointmentModelCategory?.appointments = [];
//            response.data['family_member'].forEach((f){
//              appointmentModelCategory.familyMember.add(FamilyListModel.fromJson(f));
//            });

            appointmentModelList = AppointmentModelList.fromJson(response.data['user_appointment'])
              ..appointments.addAll(familyApp.appointments);
            appointmentModelCategory =
                AppointmentModelList.fromJson(response.data['user_appointment'])
                  ..appointments.addAll(familyApp.appointments);
            setState(() {
              familyLoader = false;
            });
          } else {
            userApp.appointments.addAll(familyApp.appointments);
            appointmentModelList.appointments.addAll(userApp.appointments);
            appointmentModelCategory.appointments.addAll(userApp.appointments);
          }

          String nowDate = DateTime.now().toString().substring(0, 10).replaceAll("-", "");
          String nowTime = DateTime.now().toString().substring(11, 19).replaceAll(":", "");
          appointmentModelCategory.appointments = [];
          appointmentModelList.appointments.forEach((test) {
            //current appointments
            if (test.Status == 0 &&
                int.parse((test.appointmentDate).replaceAll("-", "")) == int.parse(nowDate) &&
                int.parse(nowTime) < int.parse((test.appointmentTime).replaceAll(":", ""))) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          appointmentModelList.appointments.forEach((test) {
            //upcoming appointments
            if (test.Status == 0 &&
                int.parse((test.appointmentDate).replaceAll("-", "")) > int.parse(nowDate)) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          appointmentModelList.appointments.forEach((test) {
            //cancel appointments
            if (test.Status == 1 &&
                int.parse((test.appointmentDate).replaceAll("-", "")) >= int.parse(nowDate)) {
              appointmentModelCategory.appointments.add(test);
            }
          });
          appointmentModelList.appointments.forEach((test) {
            //expire appointments
            if (((test.Status == 0 || test.Status == 1) &&
                    int.parse((test.appointmentDate).replaceAll("-", "")) < int.parse(nowDate)) ||
                (int.parse((test.appointmentDate).replaceAll("-", "")) == int.parse(nowDate) &&
                    int.parse(nowTime) > int.parse((test.appointmentTime).replaceAll(":", "")) &&
                    !(test.Status == 1))) {
              appointmentModelCategory.appointments.add(test);
            }
          });

          (response.data['user_appointment']['last_page'] >
                  response.data['family_appointment']['last_page'])
              ? lastPage = response.data['user_appointment']['last_page']
              : lastPage = response.data['family_appointment']['last_page'];
          //_currentPage = _currentPage + 1 ;
        }
      }
      if (appointmentModelList != null) {
        appointmentModelList.appointments
            .sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
        appointmentModelCategory.appointments
            .sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      }

      AppointmentModelList.saveAllAppointments(appointmentModelCategory.toJson());

      _bothfilter();
    }
    setState(() {
      familyLoader = false;
    });

    ///---For Offline
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
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          trailingIcon: NotificationIcon(
            lightColor: true,
          ),
          centerWigets: _center(),
          leadingIcon: _leadingIcon(),
        ),
      ),
      drawer: Container(
        width: size.convertWidth(context, 350),
        child: openDrawer(),
      ),
      bottomNavigationBar: CustomBottomBar(
        select: 2,
      ),
      body: Stack(
        children: <Widget>[
          _body(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: dropDownWidget(),
          ),
        ],
      ),
    );
  }

  Widget dropDownWidget() {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MenuButton(
                    inContainerHeight: size.convert(context, 150),
                    outContainerHeight: size.convert(context, 150),
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
                                    text: categoryTypeName ??
                                        otherList.appointmentCategories(context)[0]["typeName"],
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
                    items: otherList.appointmentCategories(context) ?? [],
                    itemBuilder: (category) {
                      if (category is Map) {
                        return SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            //height: size.longestSide*0.04978038067,
                            //width: size.longestSide*0.229868228,
                            height: size.convert(context, 30),
                            width: size.convert(context, 148),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                          text: category["typeName"],
                                          style: TextStyle(
                                              fontSize: size.convert(context, 14),
                                              fontFamily: "LatoBold",
                                              color: buttonColor)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                      color: portionColor,
                    ),
                    onItemSelected: (value) async {
//                      {"typeId": 7,"typeName":"All"},
//                      {"typeId": 0,"typeName":"Upcoming"},
//                      {"typeId": 1,"typeName":"Current"},
//                      {"typeId": 2,"typeName":"Cancel"},
//                      {"typeId": 3,"typeName":"Expired"},
//                      Current Appointment:
//                      if status = 0 AND appointment_date = today_date.
//
//                      Upcoming Appointment:
//                      if status = 0 AND appointment_date >  today_date.
//
//                      Cancel Appointment:
//                      if status = 1 AND appointment_date >  today_date.
//
//                      Expired Appointment:
//                      if status = 0 OR status = 1  AND  appointment_date <  today_date.
                      String nowDate =
                          DateTime.now().toString().substring(0, 10).replaceAll("-", "");
                      String nowTime =
                          DateTime.now().toString().substring(11, 19).replaceAll(":", "");
                      //String appointmentTime = appointmentModel?.appointmentTime.replaceAll(":", "");
                      int i = 0;
                      if (value is Map) {
//                        if(value["typeId"] == 0){
//                          print("this is upcoming appointments");
//                          appointmentModelCategory.appointments =[];
//                          appointmentModelList.appointments.forEach((test){
//                            if(test.Status == 0 && double.parse((test.appointmentDate).replaceAll("-", "")) > double.parse(nowDate)){
//                              print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
//                              print("now data = ${int.parse(nowDate)}");
//                              appointmentModelCategory.appointments.add(test);
//                            }
//                            setState(() {});
//                          });
//                        }
//                        else if(value["typeId"] == 1){
//                          print("this is current appointments");
//                          appointmentModelCategory.appointments =[];
//                          appointmentModelList.appointments.forEach((test){
//                            double appointmentTime = double.parse(test.appointmentTime.replaceAll(":", ""));
//                            if(test.Status == 0 && double.parse((test.appointmentDate).replaceAll("-", "")) == double.parse(nowDate) && double.parse(nowTime) < appointmentTime){
//                              print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
//                              print("now data = ${int.parse(nowDate)}");
//                              appointmentModelCategory.appointments.add(test);
//                            }
//                            setState(() {});
//                          });
//
//                        }
//                        else if(value["typeId"] == 2){
//                          print("this is cancel appointments");
//                          appointmentModelCategory.appointments =[];
//                          appointmentModelList.appointments.forEach((test){
//                            if(test.Status == 1 && double.parse((test.appointmentDate).replaceAll("-", "")) >= double.parse(nowDate)){
//                              print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
//                              print("now data = ${int.parse(nowDate)}");
//                              appointmentModelCategory.appointments.add(test);
//                            }
//                            setState(() {});
//                          });
//
//                        }
//                        else if(value["typeId"] == 3){
//                          print("this is expire appointments");
//                          appointmentModelCategory.appointments =[];
//                          appointmentModelList.appointments.forEach((test){
//                            double appointmentTime = double.parse(test.appointmentTime.replaceAll(":", ""));
//                            if(((test.Status == 0 || test.Status == 1) && double.parse((test.appointmentDate).replaceAll("-", "")) < double.parse(nowDate))  || ( double.parse((test.appointmentDate).replaceAll("-", "")) ==  double.parse(nowDate)  && double.parse(nowTime)  > appointmentTime && !(test.Status == 1) )){
//                              print("appointment data = ${int.parse((test.appointmentDate).replaceAll("-", ""))}");
//                              print("now data = ${int.parse(nowDate)}");
//                              appointmentModelCategory.appointments.add(test);
//                            }
//                            setState(() {});
//                          });
//
//                        }
//                        else if(value["typeId"] == 7){
//                          print("all all all all all ");
//                            appointmentModelCategory.appointments = [];
//                          appointmentModelCategory = await AppointmentModelList.getAllAppointments();
//                          setState(() {});
//                        }
//                        print("length of appointmentModelCategory = ${appointmentModelCategory.appointments.length}");
//                        print("length of appointmentModelList = ${appointmentModelList.appointments.length  }");
                        setState(() {
                          categoryTypeId = value["typeId"];
                          categoryTypeName = value["typeName"];
                        });
                        _bothfilter();
                        // print("id = ${categoryTypeId}");
                        // _getUserAppointment();
                      }
                      // Action when new item is selected
                    },
                    toggledChild: Container()
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
                familyListModel == null
                    ? SizedBox(width: 18, height: 18, child: FittedBox(child: Loading()))
                    : MenuButton(
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
                                        text: selectedUserName ?? TranslationBase.of(context).all,
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
                        items: familyListModel?.familiesModel ?? [],
                        itemBuilder: (family) {
                          if (family is FamilyProfileModel) {
                            return SingleChildScrollView(
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: size.convert(context, 30),
                                width: size.convert(context, 148),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                              text: family.pName,
                                              style: TextStyle(
                                                  fontSize: size.convert(context, 14),
                                                  fontFamily: "LatoBold",
                                                  color: buttonColor)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                          color: portionColor,
                        ),
                        onItemSelected: (value) {
                          if (value is FamilyProfileModel) {
                            setState(() {
                              print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
                              print(value.patientID);
                              print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
                              selectedUserName = value.pName;
                              selectedUserId = value.patientID as int;
                            });
                            _getUserAppointment(loadPrefs: true);
                          }
                          // Action when new item is selected
                        },
                        toggledChild: Container()
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  double dropDownHeight() {
    if (familyListModel?.familiesModel != null) {
      if (familyListModel.familiesModel.length > 10) {
        return 400;
      } else {
        print("greater then 5");
        print("${(familyListModel.familiesModel.length + 1) * 30.1}");
        return (familyListModel.familiesModel.length) * 35.0;
      }
    } else {
      return 0.1;
    }
  }

  _leadingIcon() {
    return Container(
      height: size.convert(context, 45),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                print("open drawer ....");
                _scaffoldkey.currentState.openDrawer();
                openDrawer();
              },
              child: Icon(
                IcoFontIcons.navigationMenu,
                color: appBarIconColor,
                size: size.convert(context, 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  openDrawer() {
    return Drawer(
      child: CustomDrawer(),
    );
  }

  _body() {
    GlobalProvider provider;
    try {
      provider = Provider.of<GlobalProvider>(context);
      newMessageArriveFrom = provider.userUnSeenChatMessages;
      print("////////////////////////////////////////////////////////////");
      print("${newMessageArriveFrom.length}");
      print("////////////////////////////////////////////////////////////");
    } catch (e) {}
    Size size1 = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: EdgeInsets.only(top: 40),
      child: familyLoader
          ? Center(
              child: Loading(),
            )
          : (appointmentModelCategory?.appointments?.length ?? 0) == 0
              ? Center(
                  child: Text(TranslationBase.of(context).noAppointmentFound),
                )
              : ListView.separated(
                  itemCount: appointmentModelCategory?.appointments?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    AppointmentModel appointmentModel =
                        appointmentModelCategory.appointments[index];

                    DateTime appDate = appointmentModel.appointmentDate == null
                        ? null
                        : DateTime.parse(appointmentModel.appointmentDate);

                    List<String> appTimeString = appointmentModel.appointmentTime != null
                        ? appointmentModel.appointmentTime.split(':')
                        : ["0", "0", "0"];

                    DateTime appTime = appointmentModel.appointmentDate != null && appDate != null
                        ? DateTime(appDate.year, appDate.month, appDate.day,
                            int.parse(appTimeString[0]), int.parse(appTimeString[1]))
                        : null;
                    String appointmentDate = appointmentModel?.appointmentDate.replaceAll("-", "");
                    String nowDate = DateTime.now().toString().substring(0, 10).replaceAll("-", "");
                    String nowTime =
                        DateTime.now().toString().substring(11, 19).replaceAll(":", "");
                    String appointmentTime = appointmentModel?.appointmentTime.replaceAll(":", "");
//                    appointmentDate = appointmentDate + appointmentTime;
//                    nowDate = nowDate + nowTime;
                    print("//////////////////////////////////////////////");
                    print("appointment date =${appointmentDate}");
                    print("appointment Time =${appointmentTime}");
                    print("Now date = ${nowDate}");
                    print("Now Time = ${nowTime}");
                    print("//////////////////////////////////////////////");
                    //                      {"typeId": 7,"typeName":"All"},
//                      {"typeId": 0,"typeName":"Upcoming"},
//                      {"typeId": 1,"typeName":"Current"},
//                      {"typeId": 2,"typeName":"Cancel"},
//                      {"typeId": 3,"typeName":"Expired"},
                    return Hero(
                      tag: "detail$index",
                      child: GestureDetector(
                        onTap: () {
                          print("navigate to detail screen $index");
                          //getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(type: PageTransitionType.fade, child: blogDetail(detail: data[index], index: index,)));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: size.convert(context, 5)),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(color: Color(0xfff8F8F8)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: selectColor(
                                      appointmentModel?.Status,
                                      nowdate: double.parse(nowDate),
                                      appdate: double.parse(appointmentDate),
                                      appTime: double.parse(appointmentTime),
                                      nowTime: double.parse(nowTime),
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                          text:
                                              appDate == null ? "" : DateFormat.d().format(appDate),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "LatoBold",
                                              color: Colors.black)),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                          text: appDate == null
                                              ? ""
                                              : DateFormat.MMM().format(appDate),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "LatoBold",
                                              color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: RichText(
                                              maxLines: 1,
                                              text: TextSpan(
                                                  text:
                                                      "${appointmentModel?.title ?? ""} ${appointmentModel?.doctorName ?? ""}",
                                                  style: TextStyle(
                                                      color: buttonColor,
                                                      fontFamily: "LatoBold",
                                                      fontSize: 16)),
                                            ),
                                          ),
                                          appointmentModel?.chatIcon == "on"
                                              ? InkWell(
                                                  onTap: () {
                                                    getIt<GlobalProvider>().dispatch(
                                                        UserMessageSeen(ChateMessageNotification(
                                                            userId,
                                                            appointmentModel.patiendId,
                                                            appointmentModel.doctorID)));
                                                    if (!((appointmentModel?.Status == 1) &&
                                                        double.parse(nowDate) <
                                                            double.parse(appointmentDate))) {
                                                      getIt<GlobalSingleton>()
                                                          .navigationKey
                                                          .currentState
                                                          .push(PageTransition(
                                                              child: chatScreen(
                                                                doctorName:
                                                                    appointmentModel.doctorName,
                                                                doctorId: appointmentModel.doctorID,
                                                                patientId:
                                                                    appointmentModel.patiendId,
                                                                title:
                                                                    appointmentModel?.title ?? "",
                                                              ),
                                                              type: PageTransitionType.fade));
                                                    }
                                                  },
                                                  child: Container(
                                                      width: 25,
                                                      height: 25,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                            left: 0,
                                                            bottom: 0,
                                                            child: Icon(
                                                              Icons.message,
                                                              size: 20,
                                                              color: buttonColor,
                                                            ),
                                                          ),
                                                          newMessageArriveFrom.firstWhere(
                                                                      (chat) =>
                                                                          chat.userId == userId &&
                                                                          chat.patientId ==
                                                                              appointmentModel
                                                                                  .patiendId &&
                                                                          chat.doctorId ==
                                                                              appointmentModel
                                                                                  .doctorID,
                                                                      orElse: () => null) !=
                                                                  null
                                                              ? Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: Icon(
                                                                    Icons.brightness_1,
                                                                    size: 14,
                                                                    color: Colors.red,
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      )),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.convert(context, 5),
                                      ),
                                      Container(
                                        child: RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                            text: appTime == null
                                                ? ""
                                                : "${weekDays[appTime.weekday]} (${appointmentModel.appointmentTime.substring(0, 5)})",
                                            style: TextStyle(
                                                color: Color(0xff7e7e7e),
                                                fontFamily: "LatoRegular",
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "${appointmentModel?.address ?? ""} (${appointmentModel?.clinicName ?? ""})",
                                              style: TextStyle(
                                                  color: Color(0xff7e7e7e),
                                                  fontSize: 12,
                                                  fontFamily: "LatoRegular")),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: RichText(
                                          text: TextSpan(
                                              text: (appointmentModel?.doctorFee == 0 ||
                                                      appointmentModel?.doctorFee == null)
                                                  ? "${TranslationBase.of(context).fee}:  ${TranslationBase.of(context).free}"
                                                  : "${TranslationBase.of(context).fee}: ${appointmentModel?.doctorFee ?? ""} ${TranslationBase.of(context).currencySymbol ?? ""}",
                                              // "${TranslationBase.of(context).currencySymbol ?? ""}${appointmentModel?.doctorFee ?? ""} ",
                                              style: TextStyle(
                                                  color: Color(0xff7e7e7e),
                                                  fontSize: 12,
                                                  fontFamily: "LatoRegular")),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.convert(context, 5),
                                      ),
                                      Container(
                                        child: RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                              text:
                                                  "${appointmentModel?.userName ?? appointmentModel?.pname ?? ""}",
                                              style: TextStyle(
                                                  color: Color(0xff7e7e7e),
                                                  fontSize: 12,
                                                  fontFamily: "LatoRegular")),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.convert(context, 10),
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Divider(
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: size.convert(context, 10),
                                            ),
                                            Container(
                                              child: Row(
//                                                  status == 1 && appdate >=  nowdate
                                                mainAxisAlignment:
                                                    ((appointmentModel?.Status == 1) &&
                                                            double.parse(nowDate) <=
                                                                double.parse(appointmentDate))
                                                        ? MainAxisAlignment.center
                                                        : MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (!((appointmentModel?.Status == 0 ||
                                                                appointmentModel?.Status == 1) &&
                                                            double.parse(nowDate) >
                                                                double.parse(appointmentDate))) {
                                                          _rescheduleAppointment(appointmentModel);
                                                        }
                                                      },
                                                      child: Container(
                                                        width: ((appointmentModel?.Status == 1) &&
                                                                double.parse(nowDate) <=
                                                                    double.parse(appointmentDate))
                                                            ? size.convertWidth(context, 280)
                                                            : size1.width * 0.3190267,
                                                        height: size1.longestSide * 0.05124450951,
                                                        decoration: BoxDecoration(
                                                            color: (((appointmentModel?.Status ==
                                                                                0 ||
                                                                            appointmentModel
                                                                                    ?.Status ==
                                                                                1) &&
                                                                        double.parse(nowDate) >
                                                                            double.parse(
                                                                                appointmentDate)) ||
                                                                    (double.parse(
                                                                                appointmentDate) ==
                                                                            double.parse(nowDate) &&
                                                                        double.parse(nowTime) >
                                                                            double.parse(
                                                                                appointmentTime) &&
                                                                        !(appointmentModel
                                                                                ?.Status ==
                                                                            1)))
                                                                ? Colors.grey
                                                                : buttonColor,
                                                            borderRadius: BorderRadius.circular(5)),
                                                        child: Center(
                                                          child: RichText(
                                                            text: TextSpan(
                                                                text: TranslationBase.of(context)
                                                                    .reschdule,
                                                                style: TextStyle(
                                                                  fontFamily: "LatoBold",
                                                                  color: Colors.white,
                                                                  fontSize: 10,
                                                                )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ((appointmentModel?.Status == 1) &&
                                                          double.parse(nowDate) <=
                                                              double.parse(appointmentDate))
                                                      ? Container()
                                                      : SizedBox(
                                                          width: 10,
                                                        ),
                                                  ((appointmentModel?.Status == 1) &&
                                                          double.parse(nowDate) <=
                                                              double.parse(appointmentDate))
                                                      ? Container()
                                                      : Container(
                                                          child: GestureDetector(
                                                            onTap: appointmentModel
                                                                    .cancelAppointmentLoading
                                                                ? null
                                                                : () {
                                                                    if (!(((appointmentModel
                                                                                        ?.Status ==
                                                                                    0 ||
                                                                                appointmentModel
                                                                                        ?.Status ==
                                                                                    1) &&
                                                                            double.parse(nowDate) >
                                                                                double.parse(
                                                                                    appointmentDate)) ||
                                                                        (double.parse(
                                                                                    appointmentDate) ==
                                                                                double.parse(
                                                                                    nowDate) &&
                                                                            double.parse(nowTime) >
                                                                                double.parse(
                                                                                    appointmentTime)))) {
                                                                      cancelAppointmentDialog(
                                                                          appointmentModel, index);
                                                                    }
                                                                  },
                                                            child: Opacity(
                                                              opacity: appointmentModel
                                                                      .cancelAppointmentLoading
                                                                  ? 0.7
                                                                  : 1.0,
                                                              child: Container(
                                                                width: size1.width * 0.3190267,
                                                                height: size1.longestSide *
                                                                    0.05124450951,
                                                                decoration: BoxDecoration(
                                                                    color: (((appointmentModel?.Status == 0 || appointmentModel?.Status == 1) && double.parse(nowDate) > double.parse(appointmentDate)) ||
                                                                            (double.parse(appointmentDate) == double.parse(nowDate) &&
                                                                                double.parse(nowTime) >
                                                                                    double.parse(
                                                                                        appointmentTime)))
                                                                        ? Colors.grey
                                                                        : Colors.white
                                                                            .withOpacity(0.0),
                                                                    border: Border.all(
                                                                        width: 1,
                                                                        color: (((appointmentModel?.Status == 0 ||
                                                                                        appointmentModel?.Status ==
                                                                                            1) &&
                                                                                    double.parse(nowDate) > double.parse(appointmentDate)) ||
                                                                                (double.parse(appointmentDate) == double.parse(nowDate) && double.parse(nowTime) > double.parse(appointmentTime)))
                                                                            ? Colors.grey
                                                                            : Colors.red),
                                                                    borderRadius: BorderRadius.circular(5)),
                                                                child: Center(
                                                                  child: RichText(
                                                                    text: TextSpan(
                                                                        text: TranslationBase.of(
                                                                                context)
                                                                            .cancel_Appointment,
                                                                        style: TextStyle(
                                                                          fontFamily: "LatoBold",
                                                                          color: (((appointmentModel
                                                                                                  ?.Status ==
                                                                                              0 ||
                                                                                          appointmentModel
                                                                                                  ?.Status ==
                                                                                              1) &&
                                                                                      double.parse(
                                                                                              nowDate) >
                                                                                          double.parse(
                                                                                              appointmentDate)) ||
                                                                                  (double.parse(
                                                                                              appointmentDate) ==
                                                                                          double.parse(
                                                                                              nowDate) &&
                                                                                      double.parse(
                                                                                              nowTime) >
                                                                                          double.parse(
                                                                                              appointmentTime)))
                                                                              ? Colors.white
                                                                              : Colors.red,
                                                                          fontSize: 10,
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.convert(context, 10),
                                            ),
//                                              Row(
//                                                children: <Widget>[
//                                                  GestureDetector(
//                                                    onTap: () {
//
//                                                      getIt<GlobalSingleton>().navigationKey.currentState.push(
//
//                                                          PageTransition(
//                                                              child: chatScreen(
//                                                                doctorName:
//                                                                appointmentModel
//                                                                    .doctorName,
//                                                                doctorId:
//                                                                appointmentModel
//                                                                    .doctorID,
//                                                              ),
//                                                              type:
//                                                              PageTransitionType
//                                                                  .fade));
//                                                    },
//                                                    child: Container(
//                                                      width: size.convertWidth(
//                                                          context, 270),
//                                                      child: filledButton(
//                                                        color1: buttonColor,
//                                                        txt: TranslationBase.of(
//                                                            context)
//                                                            .sendMessage,
//                                                        h: size.convert(
//                                                            context, 35),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ],
//                                              )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 0,
                    );
                  },
                ),
    );
  }

  Color selectColor(int status, {double nowdate, double appdate, double appTime, double nowTime}) {
    print("status = ${status}");
    print("appdate = ${appdate}");
    print("nowdate = ${nowdate}");
    if (status == 0 && appdate > nowdate)
      return Colors.yellow; // upcoming
    else if (status == 0 && appdate == nowdate && nowTime < appTime)
      return Colors.green; // current
    else if (status == 1 && appdate >= nowdate)
      return Colors.orange; // cancel
    else if (((status == 0 || status == 1) && appdate < nowdate) ||
        (appdate == nowdate && nowTime > appTime && !(status == 1)))
      return Colors.red; // expired
    else
      return Colors.grey;
  }

  _cancelAppointment(AppointmentModel appointmentModel, int index) async {
    print('inside the _cancelAppointment ===================');
    print(appointmentModel.appID);
    setState(() {
      appointmentModel.cancelAppointmentLoading = true;
    });

    var response = await API(showSnackbarForError: true, context: context, scaffold: _scaffoldkey)
        .post(url: CANCEL_APPOINTMENT_URL, body: {'appointment_id': appointmentModel.appID});

    setState(() {
      appointmentModel.cancelAppointmentLoading = false;
    });

    print('value fo appointmentModel.appID -------------------');
    print(appointmentModel.appID);

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: () {
        cancelAppointmentDialog(appointmentModel, index);
      });
      return;
    }

    if (response is Response) {
      print('this condition is also true dude ........');
      print(response);
      CustomSnackBar.SnackBar_3Success(_scaffoldkey,
          title: TranslationBase.of(context).appointmnetcanceled);

      appointmentModelList.appointments.removeAt(index);
      appointmentModelCategory.appointments.removeAt(index);

      _getUserAppointment(loadPrefs: true);
    }
  }

  _rescheduleAppointment(AppointmentModel appointmentModel) {
    // appointmentModel.
    getIt<GlobalSingleton>()
        .navigationKey
        .currentState
        .push(PageTransition(
            child: selectAppointmentDate(
              updateAppointmentId: appointmentModel.appID,
              doctorId: appointmentModel.doctorID,
            ),
            type: PageTransitionType.leftToRight))
        .then((val) {
      _getUserAppointment(loadPrefs: true);
    });
  }

//  BottomBar() {
//    Color unSelectedColor = Color(0xff7e7e7e);
//    Color SelectedColor = appColor;
//    TextStyle unselectTextstyle = TextStyle(
//      fontFamily: "Lato",
//      fontSize: 12,
//      color: unSelectedColor,
//    );
//    TextStyle selectTextstyle = TextStyle(
//      fontFamily: "Lato",
//      fontSize: 12,
//      color: SelectedColor,
//    );
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 10),
//      decoration: BoxDecoration(
//        color: Color(0xfff8f8f8),
//      ),
//      height: 100,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              print("1");
//              setState(() {
//                select = 1;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(
//                    context,
//                    PageTransition(
//                        type: PageTransitionType.fade, child: HomePage()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset(
//                    "assets/icons/hospital.png",
//                    color: select == 1 ? appColor : unSelectedColor,
//                    //height: 20,
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  Text(
//                    "Book Appointment",
//                    style: select == 1 ? selectTextstyle : unselectTextstyle,
//                  )
//                ],
//              ),
//            ),
//          ),
//          GestureDetector(
//            onTap: () {
//              setState(() {
//                select = 2;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(
//                    context,
//                    PageTransition(
//                        type: PageTransitionType.fade, child: myAppointment()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset(
//                    "assets/icons/calendar.png",
//                    color: select == 2 ? appColor : unSelectedColor,
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  Text(
//                    "My Appointments",
//                    style: select == 2 ? selectTextstyle : unselectTextstyle,
//                  )
//                ],
//              ),
//            ),
//          ),
//          GestureDetector(
//            onTap: () {
//              setState(() {
//                select = 3;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(
//                    context,
//                    PageTransition(
//                        type: PageTransitionType.fade, child: medicalRecord()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset(
//                    "assets/icons/record.png",
//                    color: select == 3 ? appColor : unSelectedColor,
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  Text(
//                    "Medical Records",
//                    style: select == 3 ? selectTextstyle : unselectTextstyle,
//                  )
//                ],
//              ),
//            ),
//          ),
//          GestureDetector(
//            onTap: () {
//              setState(() {
//                select = 4;
//                getIt<GlobalSingleton>().navigationKey.currentState.push(
//                    context,
//                    PageTransition(
//                        type: PageTransitionType.fade, child: Blog()));
//              });
//            },
//            child: Container(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Image.asset(
//                    "assets/icons/blog.png",
//                    color: select == 4 ? appColor : unSelectedColor,
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  Text(
//                    "View Blogs",
//                    style: select == 4 ? selectTextstyle : unselectTextstyle,
//                  )
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  _logo() {
    return Container(
        child: SvgPicture.asset(
      "assets/icons/new_Logo_white.svg",
      height: 50,
    ));
  }

  _center() {
    return Container(
      height: size.convert(context, 45),
      child: Center(
        child: Text(TranslationBase.of(context).appointments,
            style: TextStyle(fontSize: 18, fontFamily: "LatoRegular", color: Colors.white)),
      ),
    );
  }

  cancelAppointmentDialog(AppointmentModel appointmentModel, int index) {
    //getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: size.convert(context, size.convert(context, 157)),
              width: size.convertWidth(context, 334),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.convert(context, 26),
                  ),
                  Text(
                    TranslationBase.of(context).cancel_Appointment,
                    style: TextStyle(
                      fontSize: size.convert(context, 14),
                      fontFamily: "LatoBold",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 18),
                  ),
                  Text(
                    TranslationBase.of(context).comfirmMessageCancelAppointment,
                    style: TextStyle(
                      color: portionColor,
                      fontFamily: "LatoRegular",
                      fontSize: size.convert(context, 12),
                    ),
                  ),
                  SizedBox(
                    height: size.convert(context, 24),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              print("press Cancel appointment true");
//                              Navigator.pop(context);
                              _cancelAppointment(appointmentModel, index);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: size.convertWidth(context, 87),
                              height: size.convert(context, 35),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  border: Border.all(width: 1, color: buttonColor)),
                              child: Center(
                                child: Text(
                                  TranslationBase.of(context).yes,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.convertWidth(context, 26),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              print("press Not cancel appointmet ");
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: size.convertWidth(context, 87),
                              height: size.convert(context, 35),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(size.convert(context, 5)),
                                  border: Border.all(width: 1, color: buttonColor)),
                              child: Center(
                                child: Text(
                                  TranslationBase.of(context).no,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.convert(context, 12),
                                    fontFamily: "LatoRegular",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
