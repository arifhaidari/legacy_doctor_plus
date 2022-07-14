class AppointmentModel {
  int doctorID;
  // String doctorID;
  int Status;
  // String Status;
  int appID;
  // String appID;
  String userName;
  String title;
  String doctorName;
  int doctorFee;
  String appointmentDate;
  String appointmentTime;
  String clinicName;
  String address;
  String pname;
  int patiendId;
  // String patiendId;
  String chatIcon;
  bool cancelAppointmentLoading = false;

  AppointmentModel(
      {this.doctorID,
      this.appID,
      this.userName,
      this.title,
      this.doctorName,
      this.doctorFee,
      this.appointmentDate,
      this.appointmentTime,
      this.clinicName,
      this.address,
      this.Status,
      this.pname,
      this.chatIcon,
      this.patiendId});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    doctorID = json['doctorID'];
    patiendId = json['pateint_id'] ?? json['patientID'] ?? 0;
    Status = json['Status'];
    appID = json['appID'];
    userName = json['user_name'];
    title = json['title'];
    doctorName = json['doctor_name'];
    doctorFee = json['doctor_fee'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    clinicName = json['clinic_name'];
    address = json['address'];
    pname = json['p_name'];
    chatIcon = json['chat_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorID'] = this.doctorID;
    data['Status'] = this.Status;
    data['appID'] = this.appID;
    data['user_name'] = this.userName;
    data['title'] = this.title;
    data['doctor_name'] = this.doctorName;
    data['doctor_fee'] = this.doctorFee;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['clinic_name'] = this.clinicName;
    data['address'] = this.address;
    data['p_name'] = this.pname;
    data['chat_icon'] = this.chatIcon;
    data['pateint_id'] = this.patiendId;
    return data;
  }
}
