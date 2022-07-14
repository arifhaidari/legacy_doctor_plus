import 'package:doctor_app/model/doctor/availability_status_model.dart';
import 'package:doctor_app/model/rating_model.dart';

import 'doctor_education_model.dart';
import 'doctor_experience_model.dart';
import 'doctor_model.dart';
import 'doctor_service_model.dart';
import 'doctor_specaility_model.dart';

class DoctorDetailModel {
  List<ClinicAddress> clinicAddress;
  List<FeedBackModel> doctorFeedback;
  DoctorModel doctor;
  FeedBackModel ratingModel;
  String doctorAvailable;
  bool doctorAvailableToday;
  List<DoctorSpeciality> doctorSpecialities;
  List<DoctorExperience> doctorExperiences;
  List<DoctorEducation> doctorEducations;
  List<DoctorService> doctorServices;

  DoctorDetailModel(
      {this.doctor,
      this.doctorSpecialities,
      this.doctorExperiences,
      this.doctorEducations,
      this.doctorServices,
      this.clinicAddress,
      this.doctorFeedback});

  DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['doctor_feedback'] != null) {
      doctorFeedback = new List<FeedBackModel>();
      json['doctor_feedback'].forEach((v) {
        doctorFeedback.add(new FeedBackModel.fromJson(v));
      });
    }
    ratingModel = FeedBackModel.fromJson(json);

    doctorAvailable = json['doctor_available'];

    doctorAvailableToday = doctorAvailable.toLowerCase().contains("today");

    if (json['Doctors'] != null) {
      if (json['Doctors'].length > 0) {
        doctor = DoctorModel.fromJson(json['Doctors'][0]);
      }
    }
    if (json['doctor_feedback'] != null) {
      doctorFeedback = new List<FeedBackModel>();
      json['doctor_feedback'].forEach((v) {
        doctorFeedback.add(new FeedBackModel.fromJson(v));
      });
    }

    if (json['clinic_address'] != null) {
      clinicAddress = new List<ClinicAddress>();
      json['clinic_address'].forEach((v) {
        clinicAddress.add(new ClinicAddress.fromJson(v));
      });
    } else
      doctorExperiences = new List<DoctorExperience>();

    if (json['doctorspeciality'] != null) {
      doctorSpecialities = new List<DoctorSpeciality>();
      json['doctorspeciality'].forEach((v) {
        doctorSpecialities.add(new DoctorSpeciality.fromJson(v));
      });
    } else
      doctorSpecialities = new List<DoctorSpeciality>();

    if (json['doctor_experience'] != null) {
      doctorExperiences = new List<DoctorExperience>();
      json['doctor_experience'].forEach((v) {
        doctorExperiences.add(new DoctorExperience.fromJson(v));
      });
    } else
      doctorExperiences = new List<DoctorExperience>();

    if (json['doctor_education'] != null) {
      doctorEducations = new List<DoctorEducation>();
      json['doctor_education'].forEach((v) {
        doctorEducations.add(new DoctorEducation.fromJson(v));
      });
    } else
      doctorEducations = new List<DoctorEducation>();

    if (json['doctor_services'] != null) {
      doctorServices = new List<DoctorService>();
      json['doctor_services'].forEach((v) {
        doctorServices.add(new DoctorService.fromJson(v));
      });
    } else
      doctorServices = new List<DoctorService>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.doctorSpecialities != null) {
      data['doctorspeciality'] = this.doctorSpecialities.map((v) => v.toJson()).toList();
    }
    if (this.doctorFeedback != null) {
      data['doctor_feedback'] = this.doctorFeedback.map((v) => v.toJson()).toList();
    }

    if (this.clinicAddress != null) {
      data['clinic_address'] = this.clinicAddress.map((v) => v.toJson()).toList();
    }

    if (this.doctorExperiences != null) {
      data['doctor_experience'] = this.doctorExperiences.map((v) => v.toJson()).toList();
    }
    if (this.doctorEducations != null) {
      data['doctor_education'] = this.doctorEducations.map((v) => v.toJson()).toList();
    }
    if (this.doctorServices != null) {
      data['doctor_services'] = this.doctorServices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClinicAddress {
  int id;
  // String id;
  String name;
  String address;
  int addressId;
  // String addressId;
  int clinicAddressId;
  // String clinicAddressId;
  String from;
  String to;
  // int from;
  // int to;

  ClinicAddress(
      {this.id, this.name, this.address, this.addressId, this.clinicAddressId, this.from, this.to});

  ClinicAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    addressId = json['address_id'];
    clinicAddressId = json['clinic_address_id'];
    from = json['From'];
    to = json['To'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['address_id'] = this.addressId;
    data['clinic_address_id'] = this.clinicAddressId;
    data['From'] = this.from;
    data['To'] = this.to;
    return data;
  }
}
