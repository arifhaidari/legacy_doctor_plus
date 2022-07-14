import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/res/color.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
class customCheckBox extends StatefulWidget {
  bool check ;
  customCheckBox({this.check});
  @override
  _customCheckBoxState createState() => _customCheckBoxState();
}

class _customCheckBoxState extends State<customCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
          width: size.convert(context, 18),
          height: size.convert(context, 18),
          decoration: BoxDecoration(
            border: Border.all(
              color: buttonColor,
              width: size.convert(context, 1),
            ),
            borderRadius: BorderRadius.circular(size.convert(context, 3)),
          ),

              child: Center(
                child: widget.check ? Icon(IcoFontIcons.check,
                  size: size.convert(context, 17),
                  color: buttonColor,) : Container(),
              )

    );
  }
}
