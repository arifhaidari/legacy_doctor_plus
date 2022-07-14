//import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
//import 'package:doctor_app/repeatedWidgets/CustomBottomAppBar.dart';
//import 'package:doctor_app/res/size.dart';
//import 'package:doctor_app/res/color.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_svg/svg.dart';
//import 'package:icofont_flutter/icofont_flutter.dart';
//import 'package:page_transition/page_transition.dart';
//import 'package:doctor_app/pages/medicalRecord/addmedicalRecord.dart';
//
//class medicalrecordList extends StatefulWidget {
//  @override
//  _medicalrecordListState createState() => _medicalrecordListState();
//}
//
//class _medicalrecordListState extends State<medicalrecordList> {
//  bool isexpand = false;
//  bool editProfile = false;
//
//  @override
//  Widget build(BuildContext context) {
//    Size size1 = MediaQuery.of(context).size;
//    final GlobalKey<ScaffoldState> _scaffoldkey =
//        new GlobalKey<ScaffoldState>();
//    return Scaffold(
//      key: _scaffoldkey,
//      appBar: PreferredSize(
//        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
//        child: CustomAppBar(
//          hight: size1.longestSide * 0.15666178,
//          paddingBottom: size.convert(context, 15),
//          parentContext: context,
//          color1: Color(0xff1C80A0),
//          color2: Color(0xff35D8A6),
//          leadingIcon: _leading(),
//          centerWigets: Text(
//            "Medical Record",
//            style: TextStyle(
//              color: Colors.white,
//              fontFamily: "LatoRegular",
//              fontSize: size.convert(context, 14),
//            ),
//          ),
//        ),
//      ),
//      body: _body(),
//      bottomNavigationBar: CustomBottomBar(select: 3),
//    );
//  }
//
//  _leading() {
//    return Container(
//      child: GestureDetector(
//        onTap: () {
//          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
//        },
//        child: Container(
//          child: SvgPicture.asset("assets/icons/back.svg"),
//          //child: Image.asset("assets/icons/backarrow.png"),
//        ),
//      ),
//    );
//  }
//
//  _body() {
//    return Stack(
//      children: <Widget>[
//        Container(
//          margin: EdgeInsets.only(
//            top: size.convert(context, 60),
//          ),
//          child: ListView.builder(
//              shrinkWrap: true,
//              itemCount: 1,
//              physics: ScrollPhysics(),
//              itemBuilder: (BuildContext context, int index) {
//                return Stack(
//                  children: <Widget>[
//                    AnimatedContainer(
//                      //color: Colors.green,
//                      margin: EdgeInsets.only(
//                          right: size.convert(context, 13),
//                          left: size.convert(context, 13),
//                          bottom: size.convert(context, 13)),
//                      duration: Duration(seconds: 1),
//                      child: Container(
//                        decoration: BoxDecoration(
//                            color: portionColor.withOpacity(0.05)),
//                        child: Column(
//                          children: <Widget>[
//                            Container(
//                              padding: EdgeInsets.symmetric(
//                                  horizontal: 20, vertical: 20),
//                              child: Row(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Container(
//                                    width: 40,
//                                    height: 40,
//                                    decoration: BoxDecoration(
//                                        color: Color(0xffBABABA),
//                                        borderRadius: BorderRadius.circular(5)),
//                                    child: Column(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.center,
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.center,
//                                      children: <Widget>[
//                                        RichText(
//                                          maxLines: 1,
//                                          text: TextSpan(
//                                              text: "27",
//                                              style: TextStyle(
//                                                  fontSize: 12,
//                                                  fontFamily: "LatoBold",
//                                                  color: Colors.black)),
//                                        ),
//                                        RichText(
//                                          maxLines: 1,
//                                          text: TextSpan(
//                                              text: "FEB",
//                                              style: TextStyle(
//                                                  fontSize: 12,
//                                                  fontFamily: "LatoBold",
//                                                  color: Colors.black)),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    width: 15,
//                                  ),
//                                  Expanded(
//                                    child: Container(
//                                      child: Column(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                        children: <Widget>[
//                                          Row(
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.spaceBetween,
//                                            children: <Widget>[
//                                              Container(
//                                                child: RichText(
//                                                  maxLines: 1,
//                                                  text: TextSpan(
//                                                      text: "Dr. Iqra Sohail",
//                                                      style: TextStyle(
//                                                          color: buttonColor,
//                                                          fontFamily:
//                                                              "LatoBold",
//                                                          fontSize: 16)),
//                                                ),
//                                              ),
//                                              isexpand
//                                                  ? InkWell(
//                                                      onTap: () {
//                                                        setState(() {
//                                                          editProfile =
//                                                              !editProfile;
//                                                        });
//                                                        print(editProfile);
//                                                      },
//                                                      child: Container(
//                                                        padding: EdgeInsets
//                                                            .symmetric(
//                                                                horizontal: size
//                                                                    .convert(
//                                                                        context,
//                                                                        15),
//                                                                vertical: size
//                                                                    .convert(
//                                                                        context,
//                                                                        10)),
//                                                        //  color: Colors.blueAccent,
//
//                                                        child: Center(
//                                                          child: SvgPicture.asset(
//                                                              "assets/icons/Menugreen.svg"),
//                                                        ),
//                                                      ))
//                                                  : Container(
//                                                      padding: EdgeInsets
//                                                          .symmetric(
//                                                              horizontal:
//                                                                  size.convert(
//                                                                      context,
//                                                                      15),
//                                                              vertical:
//                                                                  size.convert(
//                                                                      context,
//                                                                      5)),
//                                                      child: Center(
//                                                        child: SvgPicture.asset(
//                                                          "assets/icons/Menu.svg",
//                                                        ),
//                                                      )),
//                                            ],
//                                          ),
//                                          SizedBox(
//                                            height: 5,
//                                          ),
//                                          Container(
//                                            child: RichText(
//                                              maxLines: 1,
//                                              text: TextSpan(
//                                                text:
//                                                    "Gynecologist, Obsterician",
//                                                style: TextStyle(
//                                                    color: Color(0xff7e7e7e),
//                                                    fontFamily: "LatoRegular",
//                                                    fontSize: 12),
//                                              ),
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            height: 5,
//                                          ),
//                                          Container(
//                                            child: RichText(
//                                              text: TextSpan(
//                                                  text: "1 Prescription",
//                                                  style: TextStyle(
//                                                      color: Color(0xff7e7e7e),
//                                                      fontSize: 12,
//                                                      fontFamily:
//                                                          "LatoRegular")),
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            height: 5,
//                                          ),
//                                          Container(
//                                            child: RichText(
//                                              maxLines: 1,
//                                              text: TextSpan(
//                                                  text: "Abc",
//                                                  style: TextStyle(
//                                                      color: Color(0xff7e7e7e),
//                                                      fontSize: 12,
//                                                      fontFamily:
//                                                          "LatoRegular")),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                            _MoreDetails(),
//                            Divider(
//                              height: 1,
//                              color: portionColor,
//                            ),
//                            SizedBox(
//                              height: size.convert(context, 15),
//                            ),
//                            Container(
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                children: <Widget>[
//                                  InkWell(
//                                    onTap: () {
//                                      print("Container Expend call");
//                                      setState(() {
//                                        isexpand = !isexpand;
//                                      });
//                                      print(isexpand);
//                                    },
//                                    child: Container(
//                                      // color: Colors.yellow,
//                                      padding: EdgeInsets.symmetric(
//                                          horizontal: size.convert(context, 10),
//                                          vertical: size.convert(context, 10)),
//                                      child: Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.end,
//                                        children: <Widget>[
//                                          SvgPicture.asset(
//                                            "assets/icons/folder.svg",
//                                            color: appColor,
//                                          ),
//                                          SizedBox(
//                                            width: size.convert(context, 10),
//                                          ),
//                                          Text(
//                                            "Open",
//                                            style: TextStyle(
//                                                fontFamily: "LatoRegular",
//                                                fontSize:
//                                                    size.convert(context, 10),
//                                                color: appColor),
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                            SizedBox(
//                              height: size.convert(context, 15),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                    (editProfile && isexpand)
//                        ? Positioned(
//                            left: size.convertWidth(context, 245),
//                            top: size.convert(context, 45),
//                            child: AnimatedContainer(
//                              height: size.convert(context, 100),
//                              duration: Duration(microseconds: 3),
//                              width: size.convertWidth(context, 130),
//                              decoration: BoxDecoration(color: Colors.white),
//                              child: Column(
//                                children: <Widget>[
//                                  GestureDetector(
//                                    onTap: () {
//                                      getIt<GlobalSingleton>().navigationKey.currentState.pushReplacement(
//                                          context,
//                                          PageTransition(
//                                              child: addmedicalRecord(
//                                                buttonText: "Update Record",
//                                                key: UniqueKey(),
//                                              ),
//                                              type:
//                                                  PageTransitionType.downToUp));
//                                    },
//                                    child: Container(
//                                      padding: EdgeInsets.symmetric(
//                                          horizontal: size.convert(context, 10),
//                                          vertical: size.convert(context, 15)),
//                                      child: Row(
//                                        children: <Widget>[
//                                          SvgPicture.asset(
//                                            "assets/icons/edit.svg",
//                                            color: appColor,
//                                          ),
//                                          SizedBox(
//                                            width: size.convert(context, 10),
//                                          ),
//                                          Container(
//                                            child: Text(
//                                              "Edit Record",
//                                              style: TextStyle(
//                                                  color: Colors.black,
//                                                  fontFamily: "LatoRegular",
//                                                  fontSize: size.convert(
//                                                      context, 12)),
//                                            ),
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: size.convert(context, 8),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.symmetric(
//                                        horizontal: size.convert(context, 10)),
//                                    child: Divider(
//                                      height: size.convert(context, 1),
//                                      color: portionColor,
//                                    ),
//                                  ),
//                                  Container(
//                                    padding: EdgeInsets.symmetric(
//                                        horizontal: size.convert(context, 10),
//                                        vertical: size.convert(context, 15)),
//                                    child: Row(
//                                      children: <Widget>[
//                                        Icon(
//                                          IcoFontIcons.uiDelete,
//                                          color: appColor,
//                                          size: size.convert(context, 14),
//                                        ),
//                                        SizedBox(
//                                          width: size.convert(context, 10),
//                                        ),
//                                        Container(
//                                          child: Text(
//                                            "Delete Record",
//                                            style: TextStyle(
//                                                color: Colors.black,
//                                                fontFamily: "LatoRegular",
//                                                fontSize:
//                                                    size.convert(context, 12)),
//                                          ),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ))
//                        : SizedBox(),
//                  ],
//                );
//              }),
//        ),
//      ],
//    );
//  }
//
//  _MoreDetails() {
//    if (isexpand) {
//      return Container(
//        padding: EdgeInsets.only(left: size.convert(context, 70)),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                    child: Text(
//                  "Prescription (1) - 27 Feb, 2020",
//                  style: TextStyle(
//                    color: Colors.black,
//                    fontSize: size.convert(context, 10),
//                    fontFamily: "LatoRegular",
//                  ),
//                )),
//                SizedBox(
//                  height: size.convert(context, 14),
//                ),
//                GestureDetector(
//                    onTap: () {
//                      print("Print doc");
//                      _printDoc("assets/icons/Group 1793.png");
//                    },
//                    child: Container(
//                        child: Image.asset("assets/icons/Group 1793.png"))),
//                SizedBox(
//                  height: size.convert(context, 14),
//                ),
//              ],
//            ),
//          ],
//        ),
//      );
//    } else {
//      return Container();
//    }
//  }
//
//  _printDoc(String file) {
//    print("Print call");
//    showGeneralDialog(
//      context: context,
//      pageBuilder: (BuildContext buildContext, Animation<double> animation,
//          Animation<double> secondaryAnimation) {
//        return Wrap(
//          children: <Widget>[
//            Container(
//                width: MediaQuery.of(context).size.width,
//                height: MediaQuery.of(context).size.height,
//                color: Colors.transparent,
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: <Widget>[
//                        Container(
//                          padding: EdgeInsets.only(
//                              top: size.convert(context, 20),
//                              right: size.convert(context, 10)),
//                          child: GestureDetector(
//                              onTap: () {
//                                getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
//                              },
//                              child: Icon(
//                                Icons.clear,
//                                color: Colors.white,
//                                size: size.convert(context, 25),
//                              )),
//                        ),
//                      ],
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(top: size.convert(context, 50)),
//                      //color: Colors.yellow,
//                      height: size.convert(context, 480),
//                      width: MediaQuery.of(context).size.width,
//                      child: Image.asset(
//                        "assets/icons/Group 1793.png",
//                        height: size.convert(context, 480),
//                        width: MediaQuery.of(context).size.width,
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(top: size.convert(context, 30)),
//                      child: GestureDetector(
//                        onTap: () {
//                          print("Click on Print Doc");
//                          getIt<GlobalSingleton>().navigationKey.currentState.pop(context);
////                          getIt<GlobalSingleton>().navigationKey.currentState.push(context, PageTransition(type: PageTransitionType.rightToLeft,
////                              child: addmedicalRecord(key: UniqueKey(),)));
//                        },
//                        child: Container(
//                          height: size.convert(context, 40),
//                          margin: EdgeInsets.symmetric(
//                              horizontal: size.convert(context, 20)),
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(
//                                  size.convert(context, 5)),
//                              color: buttonColor),
//                          child: Center(
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Container(
//                                  child: RichText(
//                                    text: TextSpan(
//                                        text: "Print",
//                                        style: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: size.convert(context, 12),
//                                          fontFamily: "LatoBold",
//                                        )),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                )),
//          ],
//        );
//      },
//      barrierDismissible: true,
//      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//      barrierColor: Colors.black.withOpacity(0.75),
//      transitionDuration: const Duration(milliseconds: 200),
//    );
//  }
//}
