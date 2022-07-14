import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:flutter/material.dart';
class toggleButton extends StatefulWidget {
  Function onChange;
  double buttonWidth;
  double buttonHeight;
  double disableHeight;
  double disableWidth;
  double enableHeight;
  double enableWidth;
  Color enableColor;
  Color disableColor;
  Color dotColor;
  bool value;
  toggleButton({@required this.value,this.onChange,this.buttonWidth,this.buttonHeight,this.disableHeight,this.disableWidth,this.enableHeight,this.enableWidth,this.enableColor,this.disableColor,this.dotColor});
  @override
  _toggleButtonState createState() => _toggleButtonState();
}

class _toggleButtonState extends State<toggleButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
//        buttonEnable = !buttonEnable;
        widget.onChange(!widget.value);
      },
      child: Container(
        width: widget.buttonWidth??size.convertWidth(context, 40),
        height: widget.buttonHeight??size.convert(context, 24),
        decoration: BoxDecoration(
            color: widget.value? widget.enableColor??appColor:widget.disableColor??portionColor,
            borderRadius: BorderRadius.circular(size.convert(context, 10))),
        child: Row(
          children: <Widget>[
            !widget.value
                ?
               Container(
                margin: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
                height: widget.enableHeight??size.convert(context, 15),
                width: widget.enableWidth??size.convert(context, 15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: buttonColor??whiteColor),
              )
                : Container(
              height: widget.disableHeight??20,
              width: widget.disableWidth??15,
            ),
            widget.value
                ?  Container(
                margin: EdgeInsets.symmetric(horizontal: size.convert(context, 5)),
                height: widget.enableHeight??size.convert(context, 15),
                width: widget.disableWidth??size.convert(context, 15),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.dotColor?? ColorFilter),
              )
                : Container(
              height: widget.disableHeight??20,
              width: widget.disableWidth??15,
            ),
          ],
        ),
      ),
    );
  }
}
