import 'dart:convert';

import 'package:doctor_app/model/medical_record/medical_record_model.dart';
import 'package:doctor_app/res/offline_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecordListModel {
  int currentPage;
  List<MedicalRecordModel> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  MedicalRecordListModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  MedicalRecordListModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<MedicalRecordModel>();
      json['data'].forEach((v) {
        data.add(new MedicalRecordModel.fromJson(v));
      });
    }else{
      data = new List<MedicalRecordModel>();

    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
//    if (this.data != null) {
//      data['data'] = this.data.map((v) => v.toJson()).toList();
//    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }

  static saveMedicalRecordPref(Map json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(MEDICAL_RECORD_PREF, jsonEncode(json));
  }

  static Future<MedicalRecordListModel> getMedicalRecordPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MedicalRecordListModel model = MedicalRecordListModel.fromJson(
        jsonDecode(prefs.getString(MEDICAL_RECORD_PREF)??"{}"));
    return model.data.length == 0 ? null : model;
  }
}
