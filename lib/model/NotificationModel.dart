class NotificationModel {
  int id;
  int doctorId;
  int userId;
  int patientId;
  // String id;
  // String doctorId;
  // String userId;
  // String patientId;
  String text;
  int status;
  // String status;
  String date;
  String isChat;
  String name;
  String title;

  NotificationModel(
      {this.id,
      this.doctorId,
      this.userId,
      this.patientId,
      this.text,
      this.status,
      this.date,
      this.isChat,
      this.name,
      this.title});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    userId = json['user_id'];
    patientId = json['patient_id'];
    text = json['text'];
    status = json['status'];
    date = json['date'];
    isChat = json['is_chat'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['user_id'] = this.userId;
    data['patient_id'] = this.patientId;
    data['text'] = this.text;
    data['status'] = this.status;
    data['date'] = this.date;
    data['is_chat'] = this.isChat;
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}
