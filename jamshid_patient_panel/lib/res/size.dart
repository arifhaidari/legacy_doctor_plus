import 'package:flutter/cupertino.dart';
import 'dart:ui';

class size{
  static convert(BuildContext context,double n){
    double i = (n)/683;
    return i*MediaQuery.of(context).size.longestSide;
  }
  static convertWidth(BuildContext context,double n){
    double i = (n)/411;
    return i*MediaQuery.of(context).size.width;
  }
}


