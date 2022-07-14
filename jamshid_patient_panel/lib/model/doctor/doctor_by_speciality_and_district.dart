
import 'package:doctor_app/model/doctor/doctor_model.dart';

class DoctorBySpecialityAndDistrict {
  Doctor doctor;
  String embedPic;

  DoctorBySpecialityAndDistrict({this.doctor, this.embedPic});

  DoctorBySpecialityAndDistrict.fromJson(Map<String, dynamic> json) {
    doctor =
    json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    embedPic = json['embed_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    data['embed_pic'] = this.embedPic;
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
  Null nextPageUrl;
  String path;
  int perPage;
  Null prevPageUrl;
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
