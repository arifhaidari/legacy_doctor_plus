import 'package:doctor_app/pages/notification/notificaionList.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:doctor_app/res/size.dart';

import '../getIt.dart';

class NotificationIcon extends StatelessWidget {
  final bool lightColor;

  const NotificationIcon({Key key, @required this.lightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalProvider provider;
    try {
      provider = Provider.of<GlobalProvider>(context);
    } catch (e) {}
    print("*********HOME PROVIDER ${provider?.hasAnyUnSeenNotification}");
    return GestureDetector(
      onTap: () {
        getIt<GlobalSingleton>().navigationKey.currentState.push(
            PageTransition(
                type: PageTransitionType.fade, child: NotificationListPage()));
      },
      child: Container(
        height: size.convert(context, 45),
        width: size.convertWidth(context, 40),
        decoration: BoxDecoration(
            //shape: BoxShape.circle,
            //color: Colors.blue
            ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                IcoFontIcons.notification,
                color: lightColor ? appBarIconColor : buttonColor,
                size: size.convert(context, 26),
              ),
            ),
            Positioned(
              left: size.convertWidth(context, 23),
              top: size.convert(context, 6),
              child: Container(
                //alignment: Alignment.topRight,
                height: size.convert(context, 14),
                width: size.convert(context, 14),
                decoration: BoxDecoration(
                  color: (provider?.hasAnyUnSeenNotification ?? false)
                      ? Colors.red
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
