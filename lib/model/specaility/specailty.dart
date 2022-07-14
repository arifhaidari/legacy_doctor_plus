import 'dart:convert';

import 'package:doctor_app/res/offline_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialityModel {
  String specialityName;
  String photo;
  int specialityID;
  // String specialityID;

  SpecialityModel({this.specialityName, this.photo, this.specialityID});

  SpecialityModel.fromJson(Map<String, dynamic> json) {
    specialityName = json['specialityName'];
    photo = json['photo'];
    specialityID = json['specialityID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specialityName'] = this.specialityName;
    data['photo'] = this.photo;
    data['specialityID'] = this.specialityID;
    return data;
  }

  static saveSpecialtyList(List specialities) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SPECIALITY_PREF, jsonEncode(specialities));
  }

  static Future<List> getFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString(SPECIALITY_PREF) ?? "[]");
  }
}
