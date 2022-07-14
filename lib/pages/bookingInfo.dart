import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/server_body_model/appointment.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doctor_app/res/size.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'myAppointment.dart';

class bookingInfo extends StatefulWidget {
  final CreateAppointment appointment;

  final String patientName;
  const bookingInfo({Key key, this.appointment, this.patientName}) : super(key: key);

  @override
  _bookingInfoState createState() => _bookingInfoState();
}

class _bookingInfoState extends State<bookingInfo> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
            TranslationBase.of(context).bookingInformation,
            style: TextStyle(
              color: appBarIconColor,
              fontFamily: "LatoRegular",
              fontSize: size.convert(context, 14),
            ),
          ),
          trailingIcon: Container(
            child: GestureDetector(
              onTap: () {
                getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: myAppointment(
                      pref: false,
                    )));
              },
              child: Text(
                TranslationBase.of(context).done,
                style: TextStyle(
                  color: appBarIconColor,
                  fontFamily: "LatoRegular",
                  fontSize: size.convert(context, 15),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _body(),
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
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.convert(context, 36)),
              margin: EdgeInsets.symmetric(horizontal: size.convert(context, 80)),
              child: Image.asset(
                "assets/icons/undraw_booking_33fn.png",
                height: size.convert(context, 152),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: size.convert(context, 5)),
              child: Text(
                TranslationBase.of(context).appointmentBooked,
                style: TextStyle(
                  fontSize: size.convert(context, 12),
                  fontFamily: "LatoBold",
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: size.convert(context, 18),
            ),
            Container(
              color: portionColor.withOpacity(0.05),
              padding: EdgeInsets.only(
                top: size.convert(context, 14),
                bottom: size.convert(context, 14),
                left: size.convert(context, 24),
                right: size.convert(context, 24),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: SvgPicture.asset(
                                "assets/icons/user.svg",
                                height: size.convert(context, 17),
                                width: size.convert(context, 17),
                                color: buttonColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/doctor.svg",
                                  height: size.convert(context, 17),
                                  width: size.convert(context, 17),
                                  color: buttonColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: SvgPicture.asset(
                                "assets/icons/clock.svg",
                                height: size.convert(context, 17),
                                width: size.convert(context, 17),
                                color: buttonColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: widget.patientName ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 12),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text:
                                        "${widget?.appointment?.doctor?.title ?? ""} ${widget?.appointment?.doctor?.doctorName ?? ""}  ${widget?.appointment?.doctor?.doctorClinicAddress ?? ""}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 12),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text:
                                        "${DateFormat.yMEd().format(DateTime.parse(widget.appointment.date.replaceAll('/', '-')))} ${widget.appointment.time}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "LatoRegular",
                                      fontSize: size.convert(context, 12),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.convert(context, 18),
            ),
            Container(
              color: portionColor.withOpacity(0.05),
              padding: EdgeInsets.only(
                  left: size.convert(context, 20),
                  right: size.convert(context, 50),
                  top: size.convert(context, 16),
                  bottom: size.convert(context, 16)),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      "assets/icons/done.png",
                      color: buttonColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 8),
                      child: RichText(
                        text: TextSpan(
                            text: TranslationBase.of(context).sentMessageDoneAppointment,
                            style: TextStyle(
                              fontSize: size.convert(context, 12),
                              fontFamily: "LatoRegular",
                              color: Colors.black,
                            )),
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
  }
}
