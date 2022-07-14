import 'file_model.dart';

class MedicalRecordModel {
  int docID;
  // String docID;
  int userId;
  // String userId;
  String pateintName;
  int pateintId;
  // String pateintId;
  String doctorName;
  String recordType;
  String date;
  // String allowshareRecords;
  // String allowShareAllRecords;
  int allowshareRecords;
  int allowShareAllRecords;

  List<FileModel> files;

  bool isExpanded = false;
  bool isEditProfile = false;
  bool deleting = false;
  bool isVisibe = false;

  MedicalRecordModel(
      {this.docID,
      this.userId,
      this.pateintName,
      this.doctorName,
      this.recordType,
      this.date,
      this.allowshareRecords,
      this.allowShareAllRecords});

  MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    docID = json['docID'];
    userId = json['user_id'];
    pateintName = json['pateint_name'];
    pateintId = json['pateint_id'];
    doctorName = json['doctor_name'];
    recordType = json['record_type'];
    date = json['date'];
    allowshareRecords = json['allow_share_records'];
    allowShareAllRecords = json['allow_share_all_records'];

    files = [];
  }

  void addFile(FileModel file) {
    files.add(file);
  }
}
