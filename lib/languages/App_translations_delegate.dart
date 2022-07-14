import 'package:flutter/cupertino.dart';
import 'package:doctor_app/languages/Application.dart';
//import 'dart:async';
 import 'AppTranslation.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslation>{
  final Locale newLocale;


  AppTranslationsDelegate({this.newLocale});


  @override
  Future<AppTranslation> load(Locale locale) {
    return AppTranslation.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppTranslation> old) {
    return true;
  }
  Application application = Application();

  //typedef void LocaleChangeCallback(Locale locale);

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }
}