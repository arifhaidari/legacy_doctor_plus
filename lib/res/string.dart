library my_prj.globals;

import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class otherList{
  static List relationShipList(BuildContext context){
    return [
     { "Rid":0,"PostKey":"Father","Rname":TranslationBase.of(context).Father},
     { "Rid":1,"PostKey":"Mother","Rname":TranslationBase.of(context).Mother},
     { "Rid":2,"PostKey":"Sister","Rname":TranslationBase.of(context).Sister},
     { "Rid":3,"PostKey":"Brother","Rname":TranslationBase.of(context).Brother},
     { "Rid":4,"PostKey":"Wife","Rname":TranslationBase.of(context).Wife},
     { "Rid":5,"PostKey":"Son","Rname":TranslationBase.of(context).Son},
     { "Rid":6,"PostKey":"Daughter","Rname":TranslationBase.of(context).Daughter},
     { "Rid":7,"PostKey":"Friend","Rname":TranslationBase.of(context).Friend},
     { "Rid":8,"PostKey":"Other","Rname":TranslationBase.of(context).Other},
    ];
  }
  static List appointmentCategories(BuildContext context){
    return [
      {"typeId": 7,"typeName":TranslationBase.of(context).all},
      {"typeId": 0,"typeName":TranslationBase.of(context).upcoming},
      {"typeId": 1,"typeName":TranslationBase.of(context).current},
      {"typeId": 2,"typeName":TranslationBase.of(context).cancel},
      {"typeId": 3,"typeName":TranslationBase.of(context).expire},
    ];
  }

}


//List<String> relationShipList = [
//  "Father",
//  "Mother",
//  "Brother",
//  "Sister",
//  "Wife",
//  "Son",
//  "Daughter",
//  "Friend",
//  "Other",
//];
class languageSelect{
  static setLanguage(String lang) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', lang);
    String newVal = await prefs.get("language");
    print("new language key is = ${newVal}");
  }


  static Future<String> getLanguage() async {
    return (await SharedPreferences.getInstance()).getString('language');
  }

}


bool g_inChatUI = false;
String g_inChatUIUserId = null;
String g_inChatUIDoctorId = null;
String g_inChatUIPatientId = null;