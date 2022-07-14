class AllClinicHospital {
  int id;
// String id;
  String name;
  String address;
  String city;
  int doctorId;
  // String doctorId;

  AllClinicHospital({this.id, this.name, this.address, this.city, this.doctorId});

  AllClinicHospital.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'];
    address = json['address'];
    city = json['city'];
    doctorId = json['doctor_id'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['doctor_id'] = this.doctorId;
    return data;
  }
}
