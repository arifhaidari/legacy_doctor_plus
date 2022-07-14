class DoctorEducation {
  int dEID;
  // String dEID;
  int dFID;
  // String dFID;
  String schoolName;
  String titleOfStudy;
  String startDate;
  String endDate;

  DoctorEducation(
      {this.dEID, this.dFID, this.schoolName, this.titleOfStudy, this.startDate, this.endDate});

  DoctorEducation.fromJson(Map<String, dynamic> json) {
    dEID = json['D_E_ID'];
    dFID = json['D_FID'];
    schoolName = json['school_name'];
    titleOfStudy = json['title_of_study'];
    startDate = json['start_Date'];
    endDate = json['end_Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['D_E_ID'] = this.dEID;
    data['D_FID'] = this.dFID;
    data['school_name'] = this.schoolName;
    data['title_of_study'] = this.titleOfStudy;
    data['start_Date'] = this.startDate;
    data['end_Date'] = this.endDate;
    return data;
  }
}
