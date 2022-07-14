class FamilyProfileModel {
  int patientID;
  // String patientID;
  int userID;
  // String userID;
  String pName;
  String pPhoto;
  String pRelation;
  String pPhoneNo;
  String birthday;
  int gender;
  // String gender;
  String bloodgroup;
  bool deleting = false;

  FamilyProfileModel(
      {this.patientID,
      this.userID,
      this.pName,
      this.pPhoto,
      this.pRelation,
      this.pPhoneNo,
      this.birthday,
      this.gender,
      this.bloodgroup});

  FamilyProfileModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('patientID'))
      patientID = json['patientID'];
    else
      patientID = json['id'];

    userID = json['user_ID'];
    pName = json['p_name'] ?? "";
    pPhoto = json['p_photo'];
    pRelation = json['p_Relation'];
    pPhoneNo = json['p_phoneNo'];
    birthday = json['birthday'];
    gender = json['gender'];
    bloodgroup = json['bloodgroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientID'] = this.patientID;
    data['user_ID'] = this.userID;
    data['p_name'] = this.pName;
    data['p_photo'] = this.pPhoto;
    data['p_Relation'] = this.pRelation;
    data['p_phoneNo'] = this.pPhoneNo;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['bloodgroup'] = this.bloodgroup;
    return data;
  }
}
