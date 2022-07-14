import 'dart:io';

class ChatModel {
  int chatID;
  int pateintId;
  int userId;
  int doctorId;
  // String chatID;
  // String doctorId;
  // String pateintId;
  // String userId;
  String isRead;
  String message;
  String date;
  String displayDate;
  int from;
  // String from;
  int to;
  // String to;
  String type;
  String file;
  String voice;
  String whoSend;

  bool loading = false;
  bool failed = false;
  bool deleteFailed = false;

  File systemFile;
  double uploadProgressValue = 0;

  bool showDateAbove = false;
  bool showDateBelow = false;

  ///-1> not playing
  ///0> loading
  ///1> playing
  int isVoicePlay = -1;

  ChatModel(
      {this.chatID,
      this.doctorId,
      this.userId,
      this.isRead,
      this.message,
      this.date,
      this.from,
      this.to,
      this.type,
      this.file,
      this.systemFile,
      this.voice,
      this.whoSend});

  ChatModel.fromJson(Map<String, dynamic> json) {
    chatID = json['chatID'];
    doctorId = json['doctor_id'];
    pateintId = json['pateint_id'] ?? json['patientID'] ?? "0";
    userId = json['user_id'];
    isRead = json['is_read']?.toString();
    message = json['message'];
    date = json['date'];
    from = json['from'];
    to = json['to'];
    type = json['type'];
    file = json['file'];
    voice = json['voice'];
    whoSend = json['who_send'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatID'] = this.chatID;
    data['doctor_id'] = this.doctorId;
    data['user_id'] = this.userId;
    data['is_read'] = this.isRead;
    data['message'] = this.message;
    data['date'] = this.date;
    data['from'] = this.from;
    data['to'] = this.to;
    data['type'] = this.type;
    data['file'] = this.file;
    data['voice'] = this.voice;
    data['who_send'] = this.whoSend;
    return data;
  }
}
