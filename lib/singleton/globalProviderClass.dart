// import 'package:connectivity/connectivity.dart';
import 'package:connectivityswift/connectivityswift.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class GlobalEvent {}

class NewNotificationArrive extends GlobalEvent {}

class AllNotificationSeen extends GlobalEvent {}

class NewChatMessageArrive extends GlobalEvent {
  // final String userId;
  // final String patientId;
  // final String doctorId;
  final int userId;
  final int patientId;
  final int doctorId;

  NewChatMessageArrive(this.userId, this.patientId, this.doctorId);
}

class UserMessageSeen extends GlobalEvent {
  final ChateMessageNotification chat;

  UserMessageSeen(this.chat);
}

class MessageListSeen extends GlobalEvent {}

class GlobalProviderSingleton {
  static GlobalProvider instanceObj;

  static GlobalProvider instance() {
    if (instanceObj != null) return instanceObj;
    return GlobalProvider.init();
  }
}

class ChateMessageNotification {
  final int userId, patientId, doctorId;
  // final String userId, patientId, doctorId;

  ChateMessageNotification(this.userId, this.patientId, this.doctorId);
}

class GlobalProvider with ChangeNotifier {
  bool hasAnyUnSeenNotification;
  bool hasAnyUnSeenChat;

  List<ChateMessageNotification> userUnSeenChatMessages = [];

  GlobalProvider.init() {
    hasAnyUnSeenNotification = false;
    _connectivity();
  }

  _connectivity() {
    Connectivityswift().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        _getListOfUnReadNotification();
      }
    });
    _getListOfUnReadNotification();
  }

  _getListOfUnReadNotification() async {
    String temp1 = await UserModel.getUserId;
    int userID = int.parse(temp1);
    if (kDebugMode) {
      userID = 19;
    }

    if (userID == null) return;

    var response = await API.getSimple(url: UNREAD_NOTIFICATION_URL + "$userID");

    if (response is Response) {
      var responseData = response.data;
      if (responseData is List) {
        if (responseData.length > 0) {
          hasAnyUnSeenNotification = true;
          notifyListeners();
        }
      }
    }
  }

  GlobalProvider._();

  dispatch(GlobalEvent event) {
    print("Pre value $hasAnyUnSeenNotification $event");

    if (event is NewNotificationArrive) {
      hasAnyUnSeenNotification = true;
    } else if (event is AllNotificationSeen) {
      hasAnyUnSeenNotification = false;
    } else if (event is NewChatMessageArrive) {
      print("NewChatMessage ${event.userId}");
      hasAnyUnSeenChat = true;
      userUnSeenChatMessages
          .add(ChateMessageNotification(event.userId, event.patientId, event.doctorId));
    } else if (event is MessageListSeen) {
      hasAnyUnSeenChat = false;
    } else if (event is UserMessageSeen) {
      userUnSeenChatMessages.removeWhere((chat) =>
          chat.userId == event.chat.userId &&
          chat.doctorId == event.chat.doctorId &&
          chat.patientId == event.chat.patientId);
    }

    notifyListeners();
  }
}
