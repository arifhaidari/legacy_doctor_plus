
class AvailabilityStatusModel {
  String doctorActive;

  AvailabilityStatusModel({this.doctorActive});

  AvailabilityStatusModel.fromJson(Map<String, dynamic> json) {
    doctorActive = json['doctor_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_active'] = this.doctorActive;
    return data;
  }
}
