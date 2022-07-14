import 'package:doctor_app/model/adressModel.dart';
import 'package:doctor_app/model/doctor/spec_star_model.dart';
import 'package:doctor_app/model/rating_model.dart';
import 'package:doctor_app/model/specaility/specailty.dart';

class DoctorModel {
  int doctorID;
  // String doctorID;
  // String pmdc;
  String title;
  String city;
  String doctorName;
  // String doctorEmail;
  // String doctorPhoneNo;
  // String doctorPassword;
  String doctorPicture;
  String doctorClinicAddress;
  String district;
  int doctorStatus;
  // String doctorStatus;
  String doctorRegDate;
  int doctorFee;
  String doctorGender;
  // String doctorBirthday;
  String doctorLastName;
  // String doctorFatherName;
  String doctorShortBiography;
  String expert;
  String experience;
  // int emailVerification;
  // String emailVerification;
  // String emailVerificationToken;
  int professionalProfileStatus;
  // String professionalProfileStatus;
  int underReview;
  // String underReview;
  List<SpecialityModel> speciality;
  List<adressModel> address;
  List<FeedBackModel> doctorFeedback;
  List<DoctorAvailable> doctorAvailable;

  SpecStarModel _specStarModel;

  DoctorModel(
      {this.doctorID,
      // this.pmdc,
      this.title,
      this.city,
      this.doctorName,
      // this.doctorEmail,
      // this.doctorPhoneNo,
      // this.doctorPassword,
      this.doctorPicture,
      this.doctorClinicAddress,
      this.district,
      this.doctorStatus,
      this.doctorRegDate,
      this.doctorFee,
      this.doctorGender,
      // this.doctorBirthday,
      this.doctorLastName,
      // this.doctorFatherName,
      this.doctorShortBiography,
      this.expert,
      this.experience,
      // this.emailVerification,
      // this.emailVerificationToken,
      this.professionalProfileStatus,
      this.underReview,
      this.speciality,
      this.address,
      this.doctorAvailable,
      this.doctorFeedback});

  set setSpecStarModel(SpecStarModel model) {
    this._specStarModel = model;
  }

  SpecStarModel get getSpecStarModel => this._specStarModel;

  DoctorModel.fromJson(Map<String, dynamic> json) {
    doctorID = json['doctorID'];
    // pmdc = json['pmdc'];
    title = json['title'];
    city = json['city'];
    doctorName = json['doctor_name'];
    // doctorEmail = json['doctor_email'];
    // doctorPhoneNo = json['doctor_phoneNo'];
    // doctorPassword = json['doctor_password'];
    doctorPicture = json['doctor_picture'];
    doctorClinicAddress = json['doctor_clinicAddress'];
    district = json['district'];
    doctorStatus = json['doctor_status'] as int;
    doctorRegDate = json['doctor_regDate'];
    doctorFee = json['doctor_fee'] as int;
    doctorGender = json['doctor_gender'];
    // doctorBirthday = json['doctor_birthday'];
    doctorLastName = json['doctor_last_name'];
    // doctorFatherName = json['doctor_father_name'];
    doctorShortBiography = json['doctor_Short_Biography'];
    expert = json['Expert'];
    experience = json['experience'];
    // emailVerification = json['email_verification'] as int;
    // emailVerificationToken = json['email_verification_token'];
    professionalProfileStatus = json['professional_profile_status'] as int;
    underReview = json['under_review'] as int;

    experience = json['experience'];
    if (json['speciality'] != null) {
      speciality = new List<SpecialityModel>();
      json['speciality'].forEach((v) {
        speciality.add(new SpecialityModel.fromJson(v));
      });
    }
    if (json['address'] != null) {
      address = new List<adressModel>();
      json['address'].forEach((v) {
        address.add(new adressModel.fromJson(v));
      });
    }

    if (json['doctor_feedback'] != null) {
      doctorFeedback = new List<FeedBackModel>();
      json['doctor_feedback'].forEach((v) {
        doctorFeedback.add(new FeedBackModel.fromJson(v));
      });
    }

    if (json['doctor_available'] != null) {
      doctorAvailable = new List<DoctorAvailable>();
      json['doctor_available'].forEach((v) {
        doctorAvailable.add(new DoctorAvailable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorID'] = this.doctorID;
    // data['pmdc'] = this.pmdc;
    data['title'] = this.title;
    data['city'] = this.city;
    data['doctor_name'] = this.doctorName;
    // data['doctor_email'] = this.doctorEmail;
    // data['doctor_phoneNo'] = this.doctorPhoneNo;
    // data['doctor_password'] = this.doctorPassword;
    data['doctor_picture'] = this.doctorPicture;
    data['doctor_clinicAddress'] = this.doctorClinicAddress;
    data['district'] = this.district;
    data['doctor_status'] = this.doctorStatus;
    data['doctor_regDate'] = this.doctorRegDate;
    data['doctor_fee'] = this.doctorFee;
    data['doctor_gender'] = this.doctorGender;
    // data['doctor_birthday'] = this.doctorBirthday;
    data['doctor_last_name'] = this.doctorLastName;
    // data['doctor_father_name'] = this.doctorFatherName;
    data['doctor_Short_Biography'] = this.doctorShortBiography;
    data['Expert'] = this.expert;
    data['experience'] = this.experience;
    // data['email_verification'] = this.emailVerification;
    // data['email_verification_token'] = this.emailVerificationToken;
    data['professional_profile_status'] = this.professionalProfileStatus;
    data['under_review'] = this.underReview;
    if (this.speciality != null) {
      data['speciality'] = this.speciality.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    if (this.doctorFeedback != null) {
      data['doctor_feedback'] = this.doctorFeedback.map((v) => v.toJson()).toList();
    }
    if (this.doctorAvailable != null) {
      data['doctor_available'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
