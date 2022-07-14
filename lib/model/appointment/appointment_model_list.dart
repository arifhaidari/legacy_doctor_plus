import 'dart:convert';

import 'package:doctor_app/model/appointment/appointment_model.dart';
import 'package:doctor_app/model/family/family_profile_list.dart';
import 'package:doctor_app/pages/drawerMenu/familyProfile.dart';
import 'package:doctor_app/res/offline_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentModelList {
  int currentPage;
  List<AppointmentModel> appointments;
  List<FamilyListModel> familyMember;
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

  AppointmentModelList(
      {this.currentPage,
      this.appointments,
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

  AppointmentModelList.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      appointments = new List<AppointmentModel>();
      json['data'].forEach((v) {
        appointments.add(new AppointmentModel.fromJson(v));
      });
    } else {
      appointments = new List<AppointmentModel>();
    }
    if (json['family_member'] != null) {
      familyMember = new List<FamilyListModel>();
      json['family_member'].forEach((v) {
        familyMember.add(new FamilyListModel.fromJson(v));
      });
    } else {
      familyMember = new List<FamilyListModel>();
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
    if (data['family_member'] != null) familyMember.map((f) => toJson()).toList();
    data['data'] = appointments.map((item) => item.toJson()).toList();

    return data;
  }

  static saveAllAppointments(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ALL_APPOINTMENT_PREF, jsonEncode(data));
  }

  static Future<AppointmentModelList> getAllAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppointmentModelList model =
        AppointmentModelList.fromJson(jsonDecode(prefs.getString(ALL_APPOINTMENT_PREF) ?? "{}"));
    return model.appointments.length == 0 ? null : model;
  }

  static saveSelfAppointment(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SELF_APPOINTMENT_PREF, jsonEncode(data));
  }

  static Future<AppointmentModelList> getSelfAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppointmentModelList model =
        AppointmentModelList.fromJson(jsonDecode(prefs.getString(SELF_APPOINTMENT_PREF) ?? "{}"));
    return model.appointments.length == 0 ? null : model;
  }

  static saveFamilyAppointment(int memberId, Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("appointment" + memberId.toString(), jsonEncode(data));
  }

  static Future<AppointmentModelList> getFamilyAppointments(String memberId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppointmentModelList model = AppointmentModelList.fromJson(
        jsonDecode(prefs.getString("appointment" + memberId.toLowerCase()) ?? "{}"));
    return model.appointments.length == 0 ? null : model;
  }
}
