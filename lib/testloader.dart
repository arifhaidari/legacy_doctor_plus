import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:doctor_app/res/color.dart';
class testLoader extends StatefulWidget {
  @override
  _testLoaderState createState() => _testLoaderState();
}

class _testLoaderState extends State<testLoader> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: SpinKitThreeBounce(
        color: logoColor,

        size: 30.0,
        controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 3200)),
      ),),
    );
  }
}
