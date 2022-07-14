import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/pages/blog.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/pages/medicalRecord.dart';
import 'package:doctor_app/pages/myAppointment.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
class CustomBottomBar extends StatefulWidget {
  int select ;

  CustomBottomBar({this.select});
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    Color unSelectedColor = Color(0xff7e7e7e);
    Color SelectedColor = buttonColor;
    TextStyle unselectTextstyle = TextStyle(
      fontFamily: "Lato",
      fontSize: 12,
      color: unSelectedColor,
    );
    TextStyle selectTextstyle = TextStyle(
      fontFamily: "Lato",
      fontSize: 12,
      color: SelectedColor,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xff7E7E7E).withOpacity(0.05),
      ),
      height: size.convert(context, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: InkWell(
              onTap: () {
                // print("1");
                // setState(() {
                //   widget.select = 1;
                // });
               if(widget.select!=1){
                 getIt<GlobalSingleton>().navigationKey.currentState.pushReplacement(
                     PageTransition(
                         type: PageTransitionType.fade, child: HomePage()));
               }
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.select == 1?
                        SvgPicture.asset("assets/new/bookappointment.svg")
                        :SvgPicture.asset("assets/new/bookappointment-off.svg"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      TranslationBase.of(context).bookAppointmentbuttontext,
                      style: widget.select == 1 ? selectTextstyle : unselectTextstyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: InkWell(
              onTap: () {
                // setState(() {
                //   widget.select = 2;
                //
                // });
               if(widget.select!=2){
                 getIt<GlobalSingleton>().navigationKey.currentState.pushReplacement(

                     PageTransition(
                         type: PageTransitionType.fade, child: myAppointment()));
               }
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.select == 2?
                    SvgPicture.asset("assets/new/myappointments.svg")
                        :SvgPicture.asset("assets/new/myappointments-off.svg"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      TranslationBase.of(context).bMy_Appointments,
                      style: widget.select == 2 ? selectTextstyle : unselectTextstyle,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: InkWell(
              onTap: () {
                // setState(() {
                //   widget.select = 3;
                //   print("index print  ${widget.select}");
                // });
                if(widget.select != 3 ){
                  getIt<GlobalSingleton>().navigationKey.currentState.pushReplacement(

                      PageTransition(
                          type: PageTransitionType.fade, child: medicalRecord()));
                }
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.select == 3?
                    SvgPicture.asset("assets/new/medicalrecords.svg")
                        :SvgPicture.asset("assets/new/medicalrecords-off.svg"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      TranslationBase.of(context).bMedical_Records,
                      style: widget.select == 3 ? selectTextstyle : unselectTextstyle,
                    )
                  ],
                ),
              ),
            ),
          ),
//          GestureDetector(
//            onTap: () {
//              setState(() {
//                widget.select = 4;
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
//                    color: widget.select == 4 ? appColor : unSelectedColor,
//                  ),
//                  SizedBox(
//                    height: 5,
//                  ),
//                  Text(
//                    "View Blogs",
//                    style: widget.select == 4 ? selectTextstyle : unselectTextstyle,
//                  )
//                ],
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}

