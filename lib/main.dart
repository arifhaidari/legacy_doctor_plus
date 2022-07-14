import 'package:doctor_app/model/OneSignalNotificationModel.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/string.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:doctor_app/splashScreen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'getIt.dart';
import 'transulation/scope_model_wrapper.dart';

void main() async {
  String lang;
  WidgetsFlutterBinding.ensureInitialized();
  lang = await languageSelect.getLanguage();
//  languageSelect.getLanguage().then((onValue){
//    lang = onValue;
//  });

  setupGetIt();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    //statusBarBrightness: Brightness.dark,
    //statusBarIconBrightness: Brightness.light,
  ));

  OneSignal.shared.init("da97d6fc-33e6-4cbe-99f0-2e31637eb9bc",
      iOSSettings: {OSiOSSettings.autoPrompt: false, OSiOSSettings.inAppLaunchUrl: true});
//  runApp(
//      DevicePreview(
//        enabled: !kReleaseMode,
//        builder: (context) => new ScopeModelWrapper(language: lang)));

  runApp(new ScopeModelWrapper(language: lang));
}
//class start{
//  String lang;
//  getlang() async {
//    lang = await languageSelect.getLanguage();
//  }
//  void main() {
//
//    WidgetsFlutterBinding.ensureInitialized();
//    WidgetsBinding.instance.addPostFrameCallback((_){
//      getlang();
//
//    });
//    setupGetIt();
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent,
//      //statusBarBrightness: Brightness.dark,
//      //statusBarIconBrightness: Brightness.light,
//    ));
//
//    OneSignal.shared.init("da97d6fc-33e6-4cbe-99f0-2e31637eb9bc", iOSSettings: {
//      OSiOSSettings.autoPrompt: false,
//      OSiOSSettings.inAppLaunchUrl: true
//    });
//    runApp(new ScopeModelWrapper(language: lang));
//  }
//}

//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'languages/AppTranslation.dart';
//import 'languages/App_translations_delegate.dart';
//import 'languages/Application.dart';
//import 'languages/appModel.dart';
//main(){
//  runApp(Homethe());
//}
//
//class Homethe extends StatefulWidget {
//  @override
//  _HometheState createState() => _HometheState();
//}
//
//class _HometheState extends State<Homethe> {
//  Application application = Application();
//  AppTranslationsDelegate _newLocaleDelegate;
//
//  @override
//  void initState() {
//    super.initState();
//    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
//    application.onLocaleChanged = onLocaleChange;
//
//    print("........................inite End......................... ");
//    try{
//      onLocaleChange(Locale("ur"));
//      AppTranslation.of(context).text("welcome_text");
//    }
//    catch(e){
//      print("////////////////catch///////////////////////");
//      print(e);
//    }
//    print("........................after welcome......................... ");
//  }
//  void onLocaleChange(Locale locale) {
//    setState(() {
//      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      localizationsDelegates: [
//        _newLocaleDelegate,
//        AppTranslationsDelegate(),
//        //provides localised strings
//        GlobalMaterialLocalizations.delegate,
//        //provides RTL support
//        GlobalWidgetsLocalizations.delegate,
//      ],
//      supportedLocales: application.supportedLocales(),
//
//      home: hhhhh(),
//    );
//  }
//}
//class hhhhh extends StatefulWidget {
//  @override
//  _hhhhhState createState() => _hhhhhState();
//}
//
//class _hhhhhState extends State<hhhhh> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(AppTranslation.of(context).text("welcome_text")),
//      ),
//        body: Container(
//      child: Column(
//        children: <Widget>[
//
//          Text(AppTranslation.of(context).text("welcome_text")),
//          Text(AppTranslation.of(context).text("first_text")),
//          ScopedModel<AppModel>(
//            builder: (context, child, model) => MaterialButton(
//              onPressed: () {
//                model.changeDirection("en");
//              },
//              height: 60.0,
//              color: const Color.fromRGBO(119, 31, 17, 1.0),
//              child: new Text(
//                AppTranslation.of(context).text("welcome_text"),
//                style: new TextStyle(
//                  color: Colors.white,
//                  fontSize: 20.0,
//                  fontWeight: FontWeight.w300,
//                  letterSpacing: 0.3,
//                ),
//              ),
//            ))
//        ],
//      ),
//    ));
//  }
//}
