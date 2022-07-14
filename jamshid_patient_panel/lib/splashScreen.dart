import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/languages/appModel.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:doctor_app/pages/home.dart';

import 'package:page_transition/page_transition.dart';
class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> with TickerProviderStateMixin {

  @override
  void initState() {

    super.initState();

    Future.delayed(Duration(seconds: 3),(){
      getIt<GlobalSingleton>().navigationKey.currentState.pushReplacement(
          PageTransition(
              child: HomePage(),
              type: PageTransitionType.rightToLeft)
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(child: SvgPicture.asset("assets/icons/logoChange.svg"),),
          SizedBox(height: 10,),
          Container(
            child: SpinKitThreeBounce(NumberOfBall: 4,
              color: logoColor,
              size: 40.0,
              controller: AnimationController(
                  vsync: this, duration: const Duration(milliseconds: 2200)),
            ),
          )
        ],
      ),
    ));
  }
}
