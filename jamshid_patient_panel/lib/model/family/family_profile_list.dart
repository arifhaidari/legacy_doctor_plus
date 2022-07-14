import 'dart:convert';

import 'package:doctor_app/model/family/family_profile_model.dart';
import 'package:doctor_app/res/offline_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyListModel {
  int currentPage;
  List<FamilyProfileModel> familiesModel;
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

  FamilyListModel(
      {this.currentPage,
      this.familiesModel,
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

  FamilyListModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      familiesModel = new List<FamilyProfileModel>();
      json['data'].forEach((v) {
        familiesModel.add(new FamilyProfileModel.fromJson(v));
      });
    } else {
      familiesModel = new List<FamilyProfileModel>();
    }
    if (json['family_member'] != null) {
      familiesModel = new List<FamilyProfileModel>();
      json['family_member'].forEach((v) {
        familiesModel.add(new FamilyProfileModel.fromJson(v));
      });
    } else {
      familiesModel = new List<FamilyProfileModel>();
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
    if (this.familiesModel != null) {
      data['family_member'] = this.familiesModel.map((v) => v.toJson()).toList();
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

  static saveFamilyProfile(Map json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FAMILY_PROFILE_PREF, jsonEncode(json));
  }

  static Future<FamilyListModel> getFamilyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FamilyListModel model =
        FamilyListModel.fromJson(jsonDecode(prefs.getString(FAMILY_PROFILE_PREF) ?? "{}"));
    return model.familiesModel.length == 0 ? null : model;
  }
}
