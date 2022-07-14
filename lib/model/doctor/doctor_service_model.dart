
class DoctorService {
  String servicesId;
  String doctorSId;
  String serviceName;

  DoctorService({this.servicesId, this.doctorSId, this.serviceName});

  DoctorService.fromJson(Map<String, dynamic> json) {
    servicesId = json['services_id'];
    doctorSId = json['doctor_s_id'];
    serviceName = json['service_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['services_id'] = this.servicesId;
    data['doctor_s_id'] = this.doctorSId;
    data['service_name'] = this.serviceName;
    return data;
  }
}
