import 'package:doctor_app/model/specaility/specailty.dart';

String assetFIle = 'assets/document/file.png';

//= [
//  SpecialityModel(
//      photo: assetFIle, specialityID: "73", specialityName: "Skin Specialist"),
//  SpecialityModel(
//      photo: assetFIle, specialityID: "74", specialityName: "Gynecologist"),
//  SpecialityModel(
//      photo: assetFIle, specialityID: "75", specialityName: "Dermatologist"),
//  SpecialityModel(
//      photo: assetFIle, specialityID: "76", specialityName: "Neruologist"),
//  SpecialityModel(
//      photo: assetFIle, specialityID: "77", specialityName: "Pediatrician"),
//  SpecialityModel(
//      photo: assetFIle, specialityID: "78", specialityName: "Urology"),
//];

//class SpecialityListModel {
//  List<SpecialityModel> specialitys;
//  String embedPic;
//
//  SpecialityListModel({this.specialitys, this.embedPic});
//
//  SpecialityListModel.fromJson(Map<String, dynamic> json) {
//    if (json['specialitys'] != null) {
//      specialitys = new List<SpecialityModel>();
//      json['specialitys'].forEach((v) {
//        specialitys.add(new SpecialityModel.fromJson(v));
//      });
//    }
//    embedPic = json['embed_pic'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.specialitys != null) {
//      data['specialitys'] = this.specialitys.map((v) => v.toJson()).toList();
//    }
//    data['embed_pic'] = this.embedPic;
//    return data;
//  }
//}
