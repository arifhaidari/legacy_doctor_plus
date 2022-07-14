import 'dart:convert';

import 'package:doctor_app/model/district.dart';
import 'package:doctor_app/model/doctor/allCliinics.dart';
import 'package:doctor_app/model/doctor/doctorClinicModel.dart';
import 'package:doctor_app/model/doctor/doctor_model.dart';
import 'package:doctor_app/model/specaility/specailty.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'specaility/speciality_list.dart';

class DoctorSpecialityModel {
  List<DistrictModel> city;
  List<DoctorModel> doctors;
  List<SpecialityModel> specialitys;
  List<AllClinicHospital> allClinicHospital;
  List<DoctorClinic> doctorClinic;
  String specialityPic;
  String doctorPic;

  DoctorSpecialityModel(
      {this.doctors, this.specialitys, this.specialityPic, this.doctorPic,this.city});

  DoctorSpecialityModel.fromJson(Map<String, dynamic> json) {
    if(json['City'] != null){
      city = new List<DistrictModel>();
      json['City'].forEach((c){
        city.add(new DistrictModel.fromJson(c));
      });
    }
    else{
      city = new List<DistrictModel>();
    }
    if (json['Doctors'] != null) {
      doctors = new List<DoctorModel>();
      json['Doctors'].forEach((v) {
        doctors.add(new DoctorModel.fromJson(v));
      });
    } else {
      doctors = new List<DoctorModel>();
    }



    if (json['doctor_clinic'] != null) {
      doctorClinic = new List<DoctorClinic>();
      json['Doctors'].forEach((v) {
        doctorClinic.add(new DoctorClinic.fromJson(v));
      });
    } else {
      doctorClinic = new List<DoctorClinic>();
    }


    if (json['all_clinic_hospital'] != null) {
      allClinicHospital = new List<AllClinicHospital>();
      json['all_clinic_hospital'].forEach((v) {
        allClinicHospital.add(new AllClinicHospital.fromJson(v));
      });
    }else {
      allClinicHospital = new List<AllClinicHospital>();
    }
    if (json['Specialitys'] != null) {
      specialitys = new List<SpecialityModel>();
      json['Specialitys'].forEach((v) {
        specialitys.add(new SpecialityModel.fromJson(v));
      });
      SpecialityModel.saveSpecialtyList(json['Specialitys']);
    } else {
      specialitys = new List<SpecialityModel>();
    }

    //specialitys = specailityList;

    specialityPic = json['speciality_pic'];
    doctorPic = json['doctor_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctors != null) {
      data['Doctors'] = this.doctors.map((v) => v.toJson()).toList();
    }
    if (this.specialitys != null) {
      data['Specialitys'] = this.specialitys.map((v) => v.toJson()).toList();
    }
    if (this.allClinicHospital != null) {
      data['all_clinic_hospital'] =
          this.allClinicHospital.map((v) => v.toJson()).toList();
    }
    if(this.doctorClinic != null){
      data['doctor_clinic'] = this.doctorClinic.map((v) => v.toJson()).toList();
    }
    if(this.city != null){
      data['City'] = this.city.map((v)=> v.toJson()).toList();
    }
    data['speciality_pic'] = this.specialityPic;
    data['doctor_pic'] = this.doctorPic;
    return data;
  }

  static doctorSpectialityCitysaveInPrefs(Map<String, dynamic> json) async{
    print("oooooooooooo Save District");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("doctorSpectialityCity", jsonEncode(json));
  }

  static Future<Map<String, dynamic>> doctorSpectialityCitygetFromPrefs() async {
    print("oooooooooooo Get District");
    final Map<String, dynamic> data = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("doctorSpectialityCity"));
    print("oooooooooooo Get District");
    return prefs.getString("doctorSpectialityCity") == null ? data : jsonDecode(prefs.getString("doctorSpectialityCity"));
  }

}
