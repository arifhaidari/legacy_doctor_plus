class DoctorClinic {
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
  Null doctorClinicAddress;
  Null district;
  String doctorStatus;
  String doctorRegDate;
  String doctorFee;
  String doctorGender;
  // String doctorBirthday;
  String doctorLastName;
  // String doctorFatherName;
  String doctorShortBiography;
  String expert;
  String experience;
  // String emailVerification;
  // String emailVerificationToken;
  String professionalProfileStatus;
  String underReview;
  String lang;
  List<Clinic> clinic;

  DoctorClinic(
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
      // this.doctorRegDate,
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
      this.lang,
      this.clinic});

  DoctorClinic.fromJson(Map<String, dynamic> json) {
    doctorID = json['doctorID'] as int;
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
    doctorStatus = json['doctor_status'];
    // doctorRegDate = json['doctor_regDate'];
    doctorFee = json['doctor_fee'];
    doctorGender = json['doctor_gender'];
    // doctorBirthday = json['doctor_birthday'];
    doctorLastName = json['doctor_last_name'];
    // doctorFatherName = json['doctor_father_name'];
    doctorShortBiography = json['doctor_Short_Biography'];
    expert = json['Expert'];
    experience = json['experience'];
    // emailVerification = json['email_verification'];
    // emailVerificationToken = json['email_verification_token'];
    professionalProfileStatus = json['professional_profile_status'];
    underReview = json['under_review'];
    lang = json['lang'];
    if (json['clinic'] != null) {
      clinic = new List<Clinic>();
      json['clinic'].forEach((v) {
        clinic.add(new Clinic.fromJson(v));
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
    // data['doctor_regDate'] = this.doctorRegDate;
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
    data['lang'] = this.lang;
    if (this.clinic != null) {
      data['clinic'] = this.clinic.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clinic {
  String id;
  String name;
  String address;
  String addressId;
  String clinicAddressId;
  String from;
  String to;

  Clinic(
      {this.id, this.name, this.address, this.addressId, this.clinicAddressId, this.from, this.to});

  Clinic.fromJson(Map<String, dynamic> json) {
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
