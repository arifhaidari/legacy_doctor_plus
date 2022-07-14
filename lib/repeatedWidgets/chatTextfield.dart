import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class chatTextfield extends StatelessWidget {
  double w;
  double h;
  Function onChange;
  Function onSubmit;
  String hints;
  TextEditingController  controller;
  chatTextfield({this.h,this.hints,this.onChange,this.w, @required this.onSubmit,this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.convert(context, 10)),
      width: w??50,
      height: h??30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: portionColor,
        )
      ),
      child: TextFormField(
        onSaved: (val){

        },
        controller: controller,
        onFieldSubmitted: (val){
          onSubmit(val);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hints??"",
        ),
      ),
    );
  }
}
