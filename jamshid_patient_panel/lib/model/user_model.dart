import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  int id;
  // String id;
  String name;
  String fName;
  String pic;
  String birthday;
  int gender;
  // String gender;
  String email;
  String phone;
  String password;
  String createdAt;
  String bloodgroup;

  UserModel(
      {this.id,
      this.name,
      this.fName,
      this.pic,
      this.birthday,
      this.gender,
      this.email,
      this.phone,
      this.password,
      this.createdAt,
      this.bloodgroup});

  Future<UserModel> fromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.id = int.parse(prefs.getString('user_id'));
    this.name = prefs.getString('user_name');
    this.pic = prefs.getString('user_pic');
    this.birthday = prefs.getString('user_dob');
    this.gender = int.parse(prefs.getString('user_gender'));
    this.email = prefs.getString('user_email');
    this.phone = prefs.getString('user_phone');
    return this;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fName = json['f_name'];
    pic = json['pic'];
    birthday = json['birthday'];
    gender = json['gender'] as int;
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    createdAt = json['created_at'];
    bloodgroup = json['bloodgroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['f_name'] = this.fName;
    data['pic'] = this.pic;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['created_at'] = this.createdAt;
    data['bloodgroup'] = this.bloodgroup;
    return data;
  }

  savePrefs() async {
    print("Saving User Prefs");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', id.toString());
    prefs.setString('user_name', name);
    prefs.setString('user_pic', pic);
    prefs.setString('user_dob', birthday);
    prefs.setString('user_gender', gender.toString());
    prefs.setString('user_email', email);
    prefs.setString('user_phone', phone);

    OneSignal.shared.sendTag('user_id', id);
  }

  // static get getUserId async => (await SharedPreferences.getInstance()).getInt('user_id');
  static get getUserId async => (await SharedPreferences.getInstance()).getString('user_id');

  static get getUserName async => (await SharedPreferences.getInstance()).getString('user_name');

  static get getUserPic async => (await SharedPreferences.getInstance()).getString('user_pic');

  static get getUserDOB async => (await SharedPreferences.getInstance()).getString('user_dob');

  static get getUserGender async =>
      (await SharedPreferences.getInstance()).getString('user_gender');

  static get getUserEmail async => (await SharedPreferences.getInstance()).getString('user_email');

  static get getUserPhone async => (await SharedPreferences.getInstance()).getString('user_phone');

  Future<UserModel> getUserModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.name = prefs.getString('user_name');
    this.birthday = prefs.getString('user_dob');
    this.gender = int.parse(prefs.getString('user_gender'));
    this.phone = prefs.getString('user_phone');
    this.pic = prefs.getString('user_pic');
    this.id = int.parse(prefs.getString('user_id'));
    return this;
  }

  static logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
    getIt<GlobalSingleton>().navigationKey.currentState.popUntil((route) => route.isFirst);
    getIt<GlobalSingleton>()
        .navigationKey
        .currentState
        .push(PageTransition(child: HomePage(), type: PageTransitionType.fade));
  }
}
