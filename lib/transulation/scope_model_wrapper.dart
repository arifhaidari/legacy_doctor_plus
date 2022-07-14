import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:doctor_app/transulation/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopeModelWrapper extends StatelessWidget {
  String language;
  ScopeModelWrapper({this.language});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalProvider>(
        create: (_) => getIt<GlobalProvider>(),

//    value: getIt<GlobalProvider>(),
        child: ScopedModel<AppModel>(model: AppModel(language: language), child: MyApp(lang: language)));
  }
}

class AppModel extends Model {
  String language;
  AppModel({this.language});
  Locale _appLocale ;

  Locale appLocal(String lang) {
    print("language is = ${language}");
    print("lang is = ${lang}");
    return  _appLocale ?? Locale(lang?? language ?? 'en');
  }

  void changeDirection(String language) {
//    if (_appLocale == Locale("ar")) {
//      _appLocale = Locale("en");
//    } else {
//      _appLocale = Locale("ar");
//    }
    _appLocale = Locale(language);
    notifyListeners();
  }
}
