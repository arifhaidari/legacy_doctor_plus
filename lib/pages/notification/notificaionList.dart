import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/NotificationModel.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/chat/chat.dart';
import 'package:doctor_app/repeatedWidgets/CustomAppBar.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/singleton/globalProviderClass.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doctor_app/res/size.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  getNotifications() async {
    String temp = await UserModel.getUserId;
    int userId = int.parse(temp);
//    if (kDebugMode) {
//      userId = "19";
//    }

    if (userId == null) {
      notifications = [];
      setState(() {});
      return;
    }

    var response = await API(scaffold: _scaffoldKey, context: context, showSnackbarForError: true)
        .get(url: ALL_NOTIFICATION_URL + userId.toString());

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldKey, context, btnFun: getNotifications);
      return;
    }

    if (response is Response) {
      var responseData = response.data["data"];
      print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
      print(responseData);
      print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
      if (responseData is List) {
        print("this is list of notification");
        getIt<GlobalProvider>().dispatch(AllNotificationSeen());
        notifications = responseData.map((json) => NotificationModel.fromJson(json)).toList();
        if (mounted) setState(() {});
      }
    }
  }

  _readNotification(NotificationModel notification) async {
    setState(() {
      notification.status = 1;
    });

    var response = await API(scaffold: _scaffoldKey, context: context, showSnackbarForError: true)
        .get(url: READ_ALL_NOTIFICATION_URL + "${notification.id}");

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldKey, context, btnFun: () {
        _readNotification(notification);
      });
      return;
    }
    if (response is Response) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size1.longestSide * 0.15666178),
        child: CustomAppBar(
          paddingBottom: size.convert(context, 15),
          hight: size1.longestSide * 0.15666178,
          parentContext: context,
          color1: Color(0xff1C80A0),
          color2: Color(0xff35D8A6),
          leadingIcon: _leading(),
          centerWigets: _center(),
        ),
      ),
      body: _body(),
    );
  }

  _leading() {
    return Container(
      child: GestureDetector(
        onTap: () {
          getIt<GlobalSingleton>().navigationKey.currentState.pop();
        },
        child: Container(
          child: SvgPicture.asset(
            "assets/icons/back.svg",
            color: appBarIconColor,
          ),

          //child: Image.asset("assets/icons/backarrow.png"),
        ),
      ),
    );
  }

  _center() {
    return Container(
      child: RichText(
        text: TextSpan(
            text: TranslationBase.of(context).notifications,
            style: TextStyle(fontSize: 14, fontFamily: "LatoRegular", color: Colors.white)),
      ),
    );
  }

  _body() {
    return notifications == null
        ? Center(
            child: Loading(),
          )
        : ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: notifications?.length ?? 0,
            itemBuilder: (context, index) => _notificationWidget(notifications[index]));
  }

  _notificationWidget(NotificationModel notification) {
    return GestureDetector(
      onTap: () {
        if (notification.isChat == "YES") {
          getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
              child: chatScreen(
                doctorName: notification.name,
                doctorId: notification.doctorId,
                patientId: notification.patientId,
                title: notification?.title ?? "",
              ),
              type: PageTransitionType.fade));
        }
        print("click gray body");
      },
      child: Container(
        color: Colors.grey[100],
//      color: notification.status == "0"
//          ? appColor.withOpacity(0.2)
//          : buttonColor.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${TranslationBase.of(context).from} ${notification?.title ?? ""} ${notification?.name ?? ""}",
                    style: TextStyle(
                        fontSize: size.convert(context, 14),
                        fontFamily: "LatoRegular",
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Text(
              notification?.text ?? "",
              style: TextStyle(
                  fontSize: size.convert(context, 14),
                  fontFamily: "LatoRegular",
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                notification?.date != null
                    ? Text(
                        DateFormat("MMMM dd, yyyy HH:mm").format(DateTime.parse(notification.date)),
                        style: TextStyle(
                            fontSize: size.convert(context, 10),
                            fontFamily: "LatoRegular",
                            color: Colors.grey[600]),
                      )
                    : SizedBox(),
                notification.status == 0
                    ? GestureDetector(
                        onTap: () {
                          _readNotification(notification);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                          child: Text(
                            TranslationBase.of(context).read,
                            style: TextStyle(
                              fontSize: size.convert(context, 12),
                              fontFamily: "LatoRegular",
                              color: buttonColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0),
                              border: Border.all(width: 1, color: buttonColor),
                              borderRadius: BorderRadius.circular(5)),
                        ))
                    : SizedBox(),
              ],
            ),
//          notification.status == "0"
//              ? GestureDetector(
//                  onTap: () {
//                    _readNotification(notification);
//                  },
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text("Read"),
//                  ))
//              : SizedBox(),
          ],
        ),
      ),
    );
  }
}
