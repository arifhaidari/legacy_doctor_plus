import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/material.dart';
class radioButton extends StatefulWidget {
  Function onchange;
  radioButton({this.onchange});
  @override
  _radioButtonState createState() => _radioButtonState();
}

class _radioButtonState extends State<radioButton> {
  bool selected = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
         Row(
          children: <Widget>[
            Text(TranslationBase.of(context).good,style: TextStyle(
                fontFamily: "LatoBold",
                fontSize: size.convert(context, 12),
                color: selected ? appColor : portionColor
            ),),
            SizedBox(width: 4,),
            InkWell(
              onTap: (){
                setState(() {
                  selected = true;
                  widget.onchange(selected);
                });
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1,
                        color: selected ? appColor :portionColor
                    )
                ),
                child: selected ?Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColor,
                      border: Border.all(
                          width: 4,
                          color: Colors.white
                      )
                  ),
                ) : Container(width: 0.1,height: 0.1,),
              ),
            ),
          ],
        ),
        SizedBox(width: size.convert(context, 10),),
        Row(
          children: <Widget>[
            Text(TranslationBase.of(context).bad,style: TextStyle(
                fontFamily: "LatoBold",
                fontSize: size.convert(context, 12),
                color: !selected ? appColor : portionColor
            ),),
            SizedBox(width: 4,),
            InkWell(
              onTap: (){
                setState(() {
                  selected = false;
                  widget.onchange(selected);
                });
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1,
                        color: !selected ? appColor :portionColor
                    )
                ),
                child: !selected ?Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColor,
                    border: Border.all(
                      width: 4,
                      color: Colors.white
                    )
                  ),
                ) : Container(width: 0.1,height: 0.1,),
              ),
            ),
          ],
        ),

      ],),
    );
  }
}
