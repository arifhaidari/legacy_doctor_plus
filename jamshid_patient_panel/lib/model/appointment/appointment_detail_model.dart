class AppointmentDetailModel {
  // String appID;
  // String doctorId;
  // String pateintId;
  // String userId;
  int appID;
  int doctorId;
  int pateintId;
  int userId;
  int clinicAddressId;
  // String clinicAddressId;
  String appointmentDate;
  String appointmentTime;
  String createdAt;
  int status;
  // String status;
  int feedback;
  // String feedback;
  // String cancelByUser;
  // String cancelByDoctor;
  int cancelByUser;
  int cancelByDoctor;

  AppointmentDetailModel(
      {this.appID,
      this.doctorId,
      this.pateintId,
      this.userId,
      this.clinicAddressId,
      this.appointmentDate,
      this.appointmentTime,
      this.createdAt,
      this.status,
      this.feedback,
      this.cancelByUser,
      this.cancelByDoctor});

  AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    appID = json['appID'];
    doctorId = json['doctor_id'];
    pateintId = json['pateint_id'];
    userId = json['user_id'];
    clinicAddressId = json['clinic_address_id'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    createdAt = json['created_at'];
    status = json['Status'];
    feedback = json['feedback'];
    cancelByUser = json['cancel_by_user'];
    cancelByDoctor = json['cancel_by_doctor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appID'] = this.appID;
    data['doctor_id'] = this.doctorId;
    data['pateint_id'] = this.pateintId;
    data['user_id'] = this.userId;
    data['clinic_address_id'] = this.clinicAddressId;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['created_at'] = this.createdAt;
    data['Status'] = this.status;
    data['feedback'] = this.feedback;
    data['cancel_by_user'] = this.cancelByUser;
    data['cancel_by_doctor'] = this.cancelByDoctor;
    return data;
  }
}
