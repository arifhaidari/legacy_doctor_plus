import 'package:doctor_app/res/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class filledButton extends StatelessWidget {
  Color color1;
  Color txtcolor;
  String txt;
  double h;
  double w;
  Color  borderColor;
  double borderwidth;
  double fontsize;
  String fontfamily;

  filledButton({this.borderColor,this.borderwidth,this.fontfamily,this.color1, this.txt,this.h,this.w,this.txtcolor,this.fontsize});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      height: h == null ? size.longestSide*0.07202928 : h,

      decoration: BoxDecoration(
          color: color1 == null ? buttonColor : color1 ,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
          width: borderwidth == null ? 0 : borderwidth,
            color: borderColor == null ? buttonColor : borderColor,
      )
      ),
      child: Center(
        child: Text(txt ==null ?"Empty":txt,
          style: TextStyle(
            color: txtcolor == null ? Colors.white : txtcolor,
            fontSize: fontsize == null ? 14 : fontsize,
            fontFamily: fontfamily == null ? "LatoRegular" : fontfamily,
          ),
        ),
      ),
    );
  }
}
