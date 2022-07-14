import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  Color color1;
  Widget iconWidget;
  Function onchange;
  String hints;
  Widget trailingIcon ;
  double borderwidth;
  TextInputType textInputType;
  TextEditingController textEditingController;
  bool obscureText;
  bool isEnable;


  CustomTextField({this.isEnable=true,this.obscureText,this.textInputType,this.borderwidth,this.trailingIcon,this.hints,this.color1, this.iconWidget,this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 5, left: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: color1 == null ? buttonColor : color1,
          width: borderwidth==null ? 2 : borderwidth ,
        ),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(

        children: <Widget>[
           iconWidget == null ? Container() : iconWidget,
          SizedBox(width: 10,),
          Expanded(
            child: TextFormField(
              enabled: isEnable,
              obscureText: obscureText ?? false,
              keyboardType: textInputType == null  ? TextInputType.text: textInputType,
              controller: textEditingController,

              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: hints==null ? "": hints,
                hintStyle: TextStyle(
                  fontSize: size.convert(context, 12),
                  fontFamily: "LatoRegular",
                  color: portionColor,

                )
              ),
              //autofocus: true,
//              style: TextStyle(
//
//              ),

            ),
          ),
          trailingIcon == null ? Container() : trailingIcon,
        ],
      ),
    );
  }
}
