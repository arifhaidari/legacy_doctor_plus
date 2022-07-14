class DoctorExperience {
  int experienceId;
  // String experienceId;
  int doctorFID;
  // String doctorFID;
  String experienceName;
  String start;
  String end;

  DoctorExperience({this.experienceId, this.doctorFID, this.experienceName, this.start, this.end});

  DoctorExperience.fromJson(Map<String, dynamic> json) {
    experienceId = json['experience_id'];
    doctorFID = json['doctor_FID'];
    experienceName = json['experience_name'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['experience_id'] = this.experienceId;
    data['doctor_FID'] = this.doctorFID;
    data['experience_name'] = this.experienceName;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
