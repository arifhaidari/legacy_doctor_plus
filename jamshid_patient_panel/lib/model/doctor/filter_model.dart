

import 'package:doctor_app/model/doctor/doctor_model.dart';

import 'spec_star_model.dart';

class FilterModel {
  String doctorAvailableToday;
  String doctorAvailableNext3Days;
  Doctor doctor;

  FilterModel(
      {this.doctorAvailableToday, this.doctorAvailableNext3Days, this.doctor});

  FilterModel.fromJson(Map<String, dynamic> json) {
    doctorAvailableToday = json['doctor_available_today'];
    doctorAvailableNext3Days = json['doctor_available_next_3_days'];
    doctor =
    json['doctor'] is Map ? new Doctor.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_available_today'] = this.doctorAvailableToday;
    data['doctor_available_next_3_days'] = this.doctorAvailableNext3Days;
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    return data;
  }
}

class Doctor {
  int currentPage;
  List<DoctorModel> doctors;
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



  Doctor(
      {this.currentPage,
        this.doctors,
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


  Doctor.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      doctors = new List<DoctorModel>();
      json['data'].forEach((v) {
        doctors.add(new DoctorModel.fromJson(v));
      });
    }else{
      doctors = new List<DoctorModel>();

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
    if (this.doctors != null) {
      data['data'] = this.doctors.map((v) => v.toJson()).toList();
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
}