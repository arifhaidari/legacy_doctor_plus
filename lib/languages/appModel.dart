import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../main.dart';

class ScopeModelWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return ScopedModel<AppModel>(model: AppModel(), child: Homethe());
  }
}

class AppModel extends Model {
  Locale _appLocale = Locale('en');
  Locale get appLocal => _appLocale ?? Locale("en");

  void changeDirection(String locale) {
//    if (_appLocale == Locale("ar")) {
//      _appLocale = Locale("en");
//    } else {
//      _appLocale = Locale("ar");
//    }
    _appLocale = Locale(locale);
    notifyListeners();
  }
}