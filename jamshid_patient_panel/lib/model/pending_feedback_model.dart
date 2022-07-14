class PendingFeedbackModel {
  int appID;
  // String appID;
  String docTitle;
  // String doctorId;
  // String pateintId;
  // String userId;
  int doctorId;
  int pateintId;
  int userId;
  String appointmentDate;
  String appointmentTime;
  String createdAt;
  int status;
  // String status;
  // String feedback;
  // String cancelByUser;
  int feedback;
  int cancelByUser;
  int doctorID;
  // String doctorID;
  String doctorName;
  String doctorEmail;
  String doctorPhoneNo;
  String doctorPassword;
  String doctorPicture;
  String doctorClinicAddress;
  String district;
  int doctorStatus;
  // String doctorStatus;
  String doctorRegDate;
  // String doctorFee;
  String doctorGender;
  int doctorFee;
  String doctorBirthday;
  String doctorLastName;
  String doctorFatherName;
  String doctorShortBiography;
  String expert;
  String experience;

  PendingFeedbackModel(
      {this.appID,
      this.doctorId,
      this.pateintId,
      this.userId,
      this.appointmentDate,
      this.appointmentTime,
      this.createdAt,
      this.status,
      this.feedback,
      this.cancelByUser,
      this.doctorID,
      this.doctorName,
      this.doctorEmail,
      this.doctorPhoneNo,
      this.doctorPassword,
      this.doctorPicture,
      this.doctorClinicAddress,
      this.district,
      this.doctorStatus,
      this.doctorRegDate,
      this.doctorFee,
      this.doctorGender,
      this.doctorBirthday,
      this.doctorLastName,
      this.doctorFatherName,
      this.doctorShortBiography,
      this.expert,
      this.experience,
      this.docTitle});

  PendingFeedbackModel.fromJson(Map<String, dynamic> json) {
    appID = json['appID'];
    doctorId = json['doctor_id'];
    pateintId = json['pateint_id'];
    userId = json['user_id'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    createdAt = json['created_at'];
    status = json['Status'];
    feedback = json['feedback'];
    cancelByUser = json['cancel_by_user'];
    doctorID = json['doctorID'];
    doctorName = json['doctor_name'];
    doctorEmail = json['doctor_email'];
    doctorPhoneNo = json['doctor_phoneNo'];
    doctorPassword = json['doctor_password'];
    doctorPicture = json['doctor_picture'];
    doctorClinicAddress = json['doctor_clinicAddress'];
    district = json['district'];
    doctorStatus = json['doctor_status'];
    doctorRegDate = json['doctor_regDate'];
    doctorFee = json['doctor_fee'];
    doctorGender = json['doctor_gender'];
    doctorBirthday = json['doctor_birthday'];
    doctorLastName = json['doctor_last_name'];
    doctorFatherName = json['doctor_father_name'];
    doctorShortBiography = json['doctor_Short_Biography'];
    expert = json['Expert'];
    experience = json['experience'];
    docTitle = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appID'] = this.appID;
    data['doctor_id'] = this.doctorId;
    data['pateint_id'] = this.pateintId;
    data['user_id'] = this.userId;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['created_at'] = this.createdAt;
    data['Status'] = this.status;
    data['feedback'] = this.feedback;
    data['cancel_by_user'] = this.cancelByUser;
    data['doctorID'] = this.doctorID;
    data['doctor_name'] = this.doctorName;
    data['doctor_email'] = this.doctorEmail;
    data['doctor_phoneNo'] = this.doctorPhoneNo;
    data['doctor_password'] = this.doctorPassword;
    data['doctor_picture'] = this.doctorPicture;
    data['doctor_clinicAddress'] = this.doctorClinicAddress;
    data['district'] = this.district;
    data['doctor_status'] = this.doctorStatus;
    data['doctor_regDate'] = this.doctorRegDate;
    data['doctor_fee'] = this.doctorFee;
    data['doctor_gender'] = this.doctorGender;
    data['doctor_birthday'] = this.doctorBirthday;
    data['doctor_last_name'] = this.doctorLastName;
    data['doctor_father_name'] = this.doctorFatherName;
    data['doctor_Short_Biography'] = this.doctorShortBiography;
    data['Expert'] = this.expert;
    data['experience'] = this.experience;
    data['title'] = this.docTitle;
    return data;
  }
}
