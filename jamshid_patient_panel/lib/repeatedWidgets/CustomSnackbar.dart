import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:flutter/material.dart';
class CustomSnackBar{

  static snackBar_success(BuildContext context,_scaffoldkey,{Icon leadingIcon, String title}){
    print("snackBar_success(context, _scaffoldkey)");
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            leadingIcon,
            SizedBox(
              width: size.convert(context, 10),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top:2.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: size.convert(context, 12),
                      color: Colors.white,
                      fontFamily: 'LatoBold'),
                ),

              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: GreenColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        elevation: 10.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
//    try{
//      _scaffoldkey.currentState.hideCurrentSnackBar();
//    }
//    catch(e){
//
//    }
  }

}