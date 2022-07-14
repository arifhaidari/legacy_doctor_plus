import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/doctor/my_doctor_list_model.dart';
import 'package:doctor_app/model/doctor/my_doctor_model.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/chat/chat.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/circularImage.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../doctorDetail.dart';

class myDoctor extends StatefulWidget {
  @override
  _myDoctorState createState() => _myDoctorState();
}

class _myDoctorState extends State<myDoctor> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool ismale = true;
  bool isself = true;

  MyDoctorModelList myDoctorModelList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doctorListData();
  }

  doctorListData() async {
    myDoctorModelList = await MyDoctorModelList.getDoctorList();
    setState(() {});

    String tempuserId = await UserModel.getUserId;
    int userId = int.parse(tempuserId);
    // String userId = await UserModel.getUserId;
    var response = await API(scaffold: _scaffoldkey, context: context, showSnackbarForError: true)
        .post(url: MY_DOCTOR_URL, body: {'user_id': userId});

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldkey, context, btnFun: doctorListData);
      return;
    }

    if (response is Response) {
      myDoctorModelList = MyDoctorModelList.fromJson(response.data);
      MyDoctorModelList.saveDoctorList(response.data);
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
      body: myDoctorModelList == null
          ? Center(
              child: Loading(),
            )
          : (myDoctorModelList?.myDoctors?.length ?? 0) == 0
              ? _body()
              : _listDoctor(),
      //drawer: openDrawer(),
    );
  }

  _body() {
    return Container(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: size.convert(context, 72)),
                //margin: EdgeInsets.symmetric(horizontal: size.convert(context, 90)),
                // color: Colors.blue,
                child: Image.asset(
                  "assets/icons/undraw_doctor_kw_5_l.png",
                  height: size.convert(context, 140),
                  width: size.convert(context, 192),
                ),
              ),
            ],
          ),

          /// ///Images in center
          // SizedBox(height: size.convert(context, 24),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: size.convert(context, 24)),
                //margin: EdgeInsets.symmetric(horizontal: size.convert(context, 90)),
                // color: Colors.blue,
                child: Text(
                  TranslationBase.of(context).noBookmarkedDoctors,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "LatoBold",
                    fontSize: size.convert(context, 12),
                  ),
                ),
              ),
            ],
          ),

          /// ///Images in center
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  //color: Colors.blue,
                  width: size.convertWidth(context, 264),
                  //padding: EdgeInsets.only(top: size.convert(context, 24)),
                  //margin: EdgeInsets.symmetric(horizontal: size.convert(context, 58)),
                  // color: Colors.blue,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: TranslationBase.of(context).favoriteDoctor,
                      style: TextStyle(
                        color: Color(0xff19769f),
                        fontFamily: "LatoRegular",
                        fontSize: size.convert(context, 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// ///Images in center
        ],
      ),
    );
  }

  _logo() {
    return Container(
      child: Text(
        TranslationBase.of(context).myDoctor,
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
          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
        },
        child: Icon(
          IcoFontIcons.longArrowLeft,
          color: appBarIconColor,
          size: size.convert(context, 25),
        ),
      ),
    );
  }

  _listDoctor() {
    return SingleChildScrollView(
      child: Container(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: myDoctorModelList?.myDoctors?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            MyDoctorModel doctorModel = myDoctorModelList.myDoctors[index];

            return Container(
                margin: EdgeInsets.symmetric(
                    vertical: size.convertWidth(context, 5),
                    horizontal: size.convertWidth(context, 13)),
                padding: EdgeInsets.symmetric(
                    horizontal: size.convertWidth(context, 10),
                    vertical: size.convert(context, 15)),
                color: portionColor.withOpacity(0.1),
                //height: 132,
                child: InkWell(
                  onTap: () {
                    getIt<GlobalSingleton>()
                        .navigationKey
                        .currentState
                        .push(PageTransition(
                            child: doctorDetail(doctorId: doctorModel.doctorID),
                            type: PageTransitionType.leftToRightWithFade))
                        .then((val) {
                      doctorListData();
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 6),
                        child: circularImage(
                          imageUrl: DOCTOR_IMAGE_URL + (doctorModel?.doctorPicture ?? ""),
                          h: 36,
                          w: 36,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        print("individual doctor detail");
//                                    getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(
//                                        child: doctorDetail(),
//                                        type: PageTransitionType.leftToRightWithFade
//                                    ));
                                      },
                                      child: Container(
                                        child: RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                              text:
                                                  "${doctorModel?.title ?? ""}${doctorModel?.doctorName ?? ""}",
                                              style: TextStyle(
                                                color: buttonColor,
                                                fontSize: 14,
                                                fontFamily: "Lato-Regular",
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    //color: Colors.yellow,
                                    child: RichText(
                                      text: TextSpan(
                                          text: doctorModel?.doctorEmail ?? "no email api",
                                          style: TextStyle(
                                              color: Color(0xff7e7e7e),
                                              fontSize: 10,
                                              fontFamily: "Lato-Regular")),
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    child: RichText(
                                      text: TextSpan(
                                          text: doctorModel?.doctorPhoneNo ?? "",
                                          style: TextStyle(
                                              color: portionColor,
                                              fontSize: 10,
                                              fontFamily: "Lato-Regular")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              //color: Colors.deepOrange,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: RichText(
                                      text: TextSpan(
                                          text: doctorModel?.expert ?? "Nill",
                                          style: TextStyle(
                                              fontFamily: "LatoRegular",
                                              fontSize: 10,
                                              color: Color(0xff000000))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: RichText(
                                      text: TextSpan(
                                          text: doctorModel?.doctorClinicAddress ?? "",
                                          style: TextStyle(
                                              color: buttonColor,
                                              fontSize: 10,
                                              fontFamily: "Lato-Regular")),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          icon: Icon(Icons.message),
                          iconSize: 22,
                          color: buttonColor,
                          onPressed: () {
                            getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
                                child: chatScreen(
                                  doctorName: doctorModel?.doctorName ?? "",
                                  doctorId: doctorModel?.doctorID,
                                  patientId: 0,
                                  title: doctorModel?.title ?? "",
                                ),
                                type: PageTransitionType.fade));
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 3,
            );
          },
        ),
      ),
    );
  }
}
