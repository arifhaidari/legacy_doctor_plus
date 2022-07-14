class MyDoctorModel {
  int doctorID;
  // String doctorID;
  String doctorName;
  String doctorEmail;
  String doctorPhoneNo;
  String doctorPicture;
  String doctorClinicAddress;
  String expert;
  String title;

  MyDoctorModel(
      {this.doctorID,
      this.doctorName,
      this.doctorEmail,
      this.doctorPhoneNo,
      this.doctorPicture,
      this.doctorClinicAddress,
      this.expert,
      this.title});

  MyDoctorModel.fromJson(Map<String, dynamic> json) {
    doctorID = json['doctorID'] as int;
    doctorName = json['doctor_name'];
    doctorEmail = json['doctor_email'];
    doctorPhoneNo = json['doctor_phoneNo'];
    doctorPicture = json['doctor_picture'];
    doctorClinicAddress = json['doctor_clinicAddress'];
    expert = json['Expert'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorID'] = this.doctorID;
    data['doctor_name'] = this.doctorName;
    data['doctor_email'] = this.doctorEmail;
    data['doctor_phoneNo'] = this.doctorPhoneNo;
    data['doctor_picture'] = this.doctorPicture;
    data['doctor_clinicAddress'] = this.doctorClinicAddress;
    data['Expert'] = this.expert;
    data['title'] = this.title;
    return data;
  }
}
