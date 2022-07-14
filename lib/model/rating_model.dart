class FeedBackModel {
  String viewAccount;
  // int viewAccount;
  String totalPatient;
  // int totalPatient;
  String totalReview;
  // int totalReview;
  String stars;
  String overallExperience;
  String doctorCheckup;
  String staffBehavior;
  String clinicEnvironment;

  FeedBackModel(
      {this.viewAccount,
      this.totalPatient,
      this.totalReview,
      this.stars,
      this.overallExperience,
      this.doctorCheckup,
      this.staffBehavior,
      this.clinicEnvironment});

  FeedBackModel.fromJson(Map<String, dynamic> json) {
    viewAccount = json['view_account'];
    totalPatient = json['total_patient'];
    totalReview = json['total_review'].toString();
    stars = json['Stars'].toString();
    overallExperience = json['overall_experience'].toString();
    doctorCheckup = json['doctor_checkup'].toString();
    staffBehavior = json['staff_behavior'].toString();
    clinicEnvironment = json['clinic_environment'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view_account'] = this.viewAccount;
    data['total_patient'] = this.totalPatient;
    data['total_review'] = this.totalReview;
    data['Stars'] = this.stars;
    data['overall_experience'] = this.overallExperience;
    data['doctor_checkup'] = this.doctorCheckup;
    data['staff_behavior'] = this.staffBehavior;
    data['clinic_environment'] = this.clinicEnvironment;
    return data;
  }
}
