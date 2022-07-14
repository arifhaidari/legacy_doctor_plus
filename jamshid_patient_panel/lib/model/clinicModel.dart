class ClinicModel {
  // String clinicId;
  // String fkClinicId;
  int clinicId;
  int fkClinicId;
  String name;
  String address;
  String city;
  int doctorId;
  // String doctorId;
  // int from;
  String from;
  // int to;
  String to;

  bool loading = false;

  ClinicModel(
      {this.clinicId,
      this.fkClinicId,
      this.name,
      this.address,
      this.city,
      this.doctorId,
      this.from,
      this.to});

  ClinicModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('address_id')) {
      clinicId = json['address_id'];
      fkClinicId = json['id'];
    } else {
      clinicId = json['id'];
    }
    name = json['name'];
    address = json['address'];
    city = json['city'];
    doctorId = json['doctor_id'];
    from = json['From'];
    to = json['To'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['doctor_id'] = this.doctorId;
    data['From'] = this.from;
    data['To'] = this.to;
    return data;
  }
}
