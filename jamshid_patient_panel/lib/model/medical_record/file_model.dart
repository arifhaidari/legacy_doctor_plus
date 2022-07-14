class FileModel {
  // String fileId;
  // String docId;
  int fileId;
  int docId;
  String document;
  // String docID;
  // String userId;
  int docID;
  int userId;
  String pateintName;
  String doctorName;
  String recordType;
  String date;

  bool delete = false;

  FileModel(
      {this.fileId,
      this.docId,
      this.document,
      this.docID,
      this.userId,
      this.pateintName,
      this.doctorName,
      this.recordType,
      this.date});

  FileModel.fromJson(Map<String, dynamic> json) {
    fileId = json['file_id'];
    docId = json['doc_id'];
    document = json['document'];
    docID = json['docID'];
    userId = json['user_id'];
    pateintName = json['pateint_name'];
    doctorName = json['doctor_name'];
    recordType = json['record_type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_id'] = this.fileId;
    data['doc_id'] = this.docId;
    data['document'] = this.document;
    data['docID'] = this.docID;
    data['user_id'] = this.userId;
    data['pateint_name'] = this.pateintName;
    data['doctor_name'] = this.doctorName;
    data['record_type'] = this.recordType;
    data['date'] = this.date;
    return data;
  }
}
