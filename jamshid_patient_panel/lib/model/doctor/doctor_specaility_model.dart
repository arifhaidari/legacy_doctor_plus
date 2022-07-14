
class DoctorSpeciality {
  String specialityName;
  String photo;

  DoctorSpeciality({this.specialityName, this.photo});

  DoctorSpeciality.fromJson(Map<String, dynamic> json) {
    specialityName = json['specialityName'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specialityName'] = this.specialityName;
    data['photo'] = this.photo;
    return data;
  }
}
