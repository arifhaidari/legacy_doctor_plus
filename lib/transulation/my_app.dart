import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/OneSignalNotificationModel.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/pages/signIn.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:doctor_app/transulation/scope_model_wrapper.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:doctor_app/splashScreen.dart';
import 'package:doctor_app/res/string.dart';

import '../splashScreen.dart';
import 'package:flushbar/flushbar_route.dart' as route;
class MyApp extends StatefulWidget {
  String lang;
  MyApp({this.lang});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  getlang() async {
//    lang = await languageSelect.getLanguage();
//  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => splashScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("selected language is ${widget.lang}");
    print("selected language is ${widget.lang}");
    print("selected language is ${widget.lang}");
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => MaterialApp(

              theme: ThemeData(accentColor: Colors.transparent),
              locale: model.appLocal(widget.lang ?? 'en'),
              localizationsDelegates: [
                const TranslationBaseDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('ar', ''), // persian
                const Locale('en', ''), // English
                const Locale('ur', ''), // pashto
              ],
              navigatorKey: getIt<GlobalSingleton>().navigationKey,
              debugShowCheckedModeBanner: false,
              //locale: DevicePreview.locale(context), // Add the locale here
              //builder: DevicePreview.appBuilder, // Add the builder here
              //theme: hrTheme,
              title: "Doctor",
              onGenerateRoute: generateRoute,
              initialRoute: '/',
            ));
  }

  @override
  void initState() {
    super.initState();

//    WidgetsBinding.instance.addPostFrameCallback((_){
//      getlang();
//    });

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
//    print(notification.jsonRepresentation());
      print(notification.payload.jsonRepresentation());
      OneSignalNotificationModel notificationModel =
          OneSignalNotificationModel.fromJson(notification.payload.rawPayload);
      getIt<GlobalProvider>().dispatch(NewNotificationArrive());

      Map<String, dynamic> additionalData = notification.payload.additionalData;
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ONE SIGNAL $additionalData $g_inChatUIPatientId ${additionalData['patient_id']}");
      if ((additionalData['is_chat'] == true ||
              additionalData['is_chat']?.toString()?.toLowerCase() == "yes") &&
            g_inChatUIDoctorId != additionalData['doctor_id'] &&
          g_inChatUIPatientId != additionalData['patient_id']) {
        getIt<GlobalProvider>().dispatch(NewChatMessageArrive(
            additionalData['user_id'], additionalData['patient_id'],additionalData['doctor_id']));
      }
      if (additionalData['is_chat']?.toString()?.toLowerCase() == "yes" &&
          g_inChatUIPatientId == additionalData['patient_id'] && g_inChatUIDoctorId == additionalData['doctor_id']) {
        // FlutterRingtonePlayer.playNotification();
      } else {
        Widget flushbBar = Flushbar(
          backgroundColor: buttonColor,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          isDismissible: true,
          titleText: Text(
            notificationModel?.title ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'LatoRegular',
            ),
          ),
          messageText: Text(
            notificationModel?.alert ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'LatoRegular',
            ),
          ),
          duration: Duration(seconds: 3),
        );

        route.FlushbarRoute _flushbarRoute = route.showFlushbar(
            context: getIt<GlobalSingleton>().navigationKey.currentContext,
            flushbar: flushbBar);
        getIt<GlobalSingleton>()
            .navigationKey
            .currentState
            .push(_flushbarRoute);
        FlutterRingtonePlayer.playNotification();
      }

//      getIt<GlobalSingleton>()
//          .navigationKey
//          .currentState
//          .push(MaterialPageRoute(
//              builder: (_) => Scaffold(
//                    body: Center(
//                      child: Text("Go back"),
//                    ),
//                  )));
    });
  }
}
