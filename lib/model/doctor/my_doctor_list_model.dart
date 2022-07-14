import 'dart:convert';

import 'package:doctor_app/res/offline_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_doctor_model.dart';

class MyDoctorModelList {
  int currentPage;
  List<MyDoctorModel> myDoctors;
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

  MyDoctorModelList(
      {this.currentPage,
      this.myDoctors,
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

  MyDoctorModelList.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      myDoctors = new List<MyDoctorModel>();
      json['data'].forEach((v) {
        myDoctors.add(new MyDoctorModel.fromJson(v));
      });
    } else
      myDoctors = new List<MyDoctorModel>();

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
    if (this.myDoctors != null) {
      data['data'] = this.myDoctors.map((v) => v.toJson()).toList();
    }
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

  static saveDoctorList(Map json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(DOCTOR_LIST_PREF, jsonEncode(json));
  }

  static Future<MyDoctorModelList> getDoctorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MyDoctorModelList model = MyDoctorModelList.fromJson(
        jsonDecode(prefs.getString(DOCTOR_LIST_PREF)??"{}"));
    return model.myDoctors.length == 0 ? null : model;
  }
}
