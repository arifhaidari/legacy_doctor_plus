
import 'package:doctor_app/error/snackbar.dart';
import 'package:flutter/material.dart';

class DebugError {
  //{
  //"message":"",
  //"errors":...
  // }
  static CheckMap(var data, GlobalKey<ScaffoldState> scaffold,bool showSnackbar ) {
    if (data is Map) {
      if (data['errors'] != null) {
        return CheckMap(data['errors'], scaffold, showSnackbar);
      } else {
        data.forEach((key, value) {
          return CheckMap(value, scaffold, showSnackbar);
        });
      }
    } else if (data is String) {
      print("/////////////Show SnackBar For Error DebuegError.ChecMap $showSnackbar");
      if (showSnackbar)
        CustomSnackBar.SnackBar_3Error(scaffold,
            title: data, leadingIcon: Icons.error_outline);
      else
        return data;
    } else if (data is List) {
      if (data.length > 0)
        return CheckMap(data[0], scaffold, showSnackbar);
      else
      if(showSnackbar)
        CustomSnackBar.SnackBar_3Error(scaffold,
            title: data.toString(), leadingIcon: Icons.error_outline);
      else return data.toString();
    }
  }
}
