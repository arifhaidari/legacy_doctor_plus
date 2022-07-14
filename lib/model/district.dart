import 'dart:convert';

import 'package:doctor_app/res/offline_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistrictModel {
  int id;
  String districtName;

  DistrictModel({this.id, this.districtName});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    // id = int.parse(json['id'] ?? "0");
    districtName = json['district_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district_name'] = this.districtName;
    return data;
  }

  @override
  bool operator ==(other) {
    if (other is DistrictModel)
      return this.districtName.toLowerCase() == other.districtName.toLowerCase() &&
          this.id == other.id;
    else
      return false;
  }

  @override
  int get hashCode => super.hashCode;

  static saveInPrefs(List jsonList) async {
    print("oooooooooooo Save District");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(DISTRICT_PREF, jsonEncode(jsonList));
  }

  static Future<List> getFromPrefs() async {
    print("oooooooooooo Get District");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString(DISTRICT_PREF));
    return jsonDecode(prefs.getString(DISTRICT_PREF) ?? "[]");
  }
}
