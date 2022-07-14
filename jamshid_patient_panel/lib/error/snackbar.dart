import 'package:flutter/material.dart';

import '../transulation/translations_delegate_base.dart';

class CustomSnackBar {
  static Color error = Colors.red[600];
  static Color success = Colors.green[600];

  static SnackBar_3Error(_scaffoldKey, {IconData leadingIcon, String title}) {
    try {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } catch (e) {}
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              leadingIcon,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.white),
            )),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 10.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static SnackBar_InfiniteError(_scaffoldKey,
      {IconData leadingIcon, String title}) {
    try {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } catch (e) {}
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              leadingIcon,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        duration: Duration(hours: 3),
        backgroundColor: error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 10.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static SnackBar_ButtonError(GlobalKey<ScaffoldState> _scaffoldKey,
      {IconData leadingIcon,
      String title,
      String buttonText,
      Function btnFun}) {
    try {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } catch (e) {}
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              leadingIcon,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: buttonText,
          onPressed: btnFun,
          textColor: Colors.white,
        ),
        duration: Duration(hours: 3),
        backgroundColor: error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 10.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static SnackBarInternet(
      GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,{Function btnFun}) {
    try {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } catch (e) {}
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                TranslationBase.of(context).internetError,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        action: btnFun!=null? SnackBarAction(
          label: TranslationBase.of(context).retry,
          onPressed: btnFun,
          textColor: Colors.white,
        ):null,
        duration: Duration(hours: btnFun!=null? 3:0,seconds: 3),
        backgroundColor: error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 1.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static SnackBar_3Success(_scaffoldKey, {IconData leadingIcon, String title}) {
    try {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } catch (e) {}
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              leadingIcon,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 10.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
