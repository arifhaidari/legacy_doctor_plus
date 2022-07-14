

import 'package:doctor_app/model/specaility/specailty.dart';

import '../rating_model.dart';

class SpecStarModel {
  List<SpecialityModel> doctorSpecialitys;
  FeedBackModel ratingModel;
  List<DoctorAvailable> doctorAvailable;

  SpecStarModel({this.doctorSpecialitys, this.doctorAvailable});

  SpecStarModel.fromJson(Map<String, dynamic> json) {
    if (json['doctor_Specialitys'] != null) {
      doctorSpecialitys = new List<SpecialityModel>();
      json['doctor_Specialitys'].forEach((v) {
        doctorSpecialitys.add(new SpecialityModel.fromJson(v));
      });
    }else{
      doctorSpecialitys = new List<SpecialityModel>();
    }
    if (json['doctor_feedback'] != null) {
     ratingModel = FeedBackModel.fromJson(json);
    }
    if (json['doctor_available'] != null) {
      doctorAvailable = new List<DoctorAvailable>();
      json['doctor_available'].forEach((v) {
        doctorAvailable.add(new DoctorAvailable.fromJson(v));
      });
    }else{
      doctorAvailable = new List<DoctorAvailable>();

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorSpecialitys != null) {
      data['doctor_Specialitys'] =
          this.doctorSpecialitys.map((v) => v.toJson()).toList();
    }

    if (this.doctorAvailable != null) {
      data['doctor_available'] =
          this.doctorAvailable.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Stars {
  int oneStar;
  int twoStar;
  int threeStar;
  int fourStar;
  int fiveStar;

  Stars(
      {this.oneStar,
        this.twoStar,
        this.threeStar,
        this.fourStar,
        this.fiveStar});

  Stars.fromJson(Map<String, dynamic> json) {
    oneStar = json['one_star'];
    twoStar = json['two_star'];
    threeStar = json['three_star'];
    fourStar = json['four_star'];
    fiveStar = json['five_star'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['one_star'] = this.oneStar;
    data['two_star'] = this.twoStar;
    data['three_star'] = this.threeStar;
    data['four_star'] = this.fourStar;
    data['five_star'] = this.fiveStar;
    return data;
  }
}

class DoctorAvailable {
  String doctorAvailableToday;
  List<DoctorAvailableThisWeak> doctorAvailableThisWeak;
//  List<Null> doctorNotAvailableThisWeak;

  DoctorAvailable(
      {this.doctorAvailableToday,
        this.doctorAvailableThisWeak,
//        this.doctorNotAvailableThisWeak
      });

  DoctorAvailable.fromJson(Map<String, dynamic> json) {
    doctorAvailableToday = json['doctor_available_today'];
    if (json['doctor_available_this_weak'] != null) {
      doctorAvailableThisWeak = new List<DoctorAvailableThisWeak>();
      json['doctor_available_this_weak'].forEach((v) {
        doctorAvailableThisWeak.add(new DoctorAvailableThisWeak.fromJson(v));
      });
    }else{
      doctorAvailableThisWeak = new List<DoctorAvailableThisWeak>();
    }
//    if (json['doctor_not_available_this_weak'] != null) {
//      doctorNotAvailableThisWeak = new List<Null>();
//      json['doctor_not_available_this_weak'].forEach((v) {
//        doctorNotAvailableThisWeak.add(new Null.fromJson(v));
//      });
//    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_available_today'] = this.doctorAvailableToday;
    if (this.doctorAvailableThisWeak != null) {
      data['doctor_available_this_weak'] =
          this.doctorAvailableThisWeak.map((v) => v.toJson()).toList();
    }
//    if (this.doctorNotAvailableThisWeak != null) {
//      data['doctor_not_available_this_weak'] =
//          this.doctorNotAvailableThisWeak.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}

class DoctorAvailableThisWeak {
  String day;

  DoctorAvailableThisWeak({this.day});

  DoctorAvailableThisWeak.fromJson(Map<String, dynamic> json) {
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    return data;
  }
}