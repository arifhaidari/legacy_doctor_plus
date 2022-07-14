class AvailabilityTimeModel {
  int vtID;
  // String vtID;
  int doctorID;
  // String doctorID;
  String day;
  String visitTime;
  int doctorActive;
  // String doctorActive;
  int timeOffOn;
  // String timeOffOn;

  bool selected = false;

  AvailabilityTimeModel(
      {this.vtID, this.doctorID, this.day, this.visitTime, this.doctorActive, this.timeOffOn});

  AvailabilityTimeModel.fromJson(Map<String, dynamic> json) {
    vtID = json['vtID'];
    doctorID = json['doctorID'];
    day = json['day'];
    visitTime = json['visit_time'];
    doctorActive = json['doctor_active'];
    timeOffOn = json['time_off_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vtID'] = this.vtID;
    data['doctorID'] = this.doctorID;
    data['day'] = this.day;
    data['visit_time'] = this.visitTime;
    data['doctor_active'] = this.doctorActive;
    data['time_off_on'] = this.timeOffOn;
    return data;
  }
}
