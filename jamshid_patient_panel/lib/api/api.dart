import 'dart:io';

// import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/error/error.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/res/global.dart';
import 'package:flutter/material.dart';

import '../transulation/translations_delegate_base.dart';
import 'api_name.dart';

class API {
  GlobalKey<ScaffoldState> _scaffold;
  BuildContext _context;
  bool _showSnackbarForError;

  Function(double) uploadProgressCallback;

  API(
      {GlobalKey<ScaffoldState> scaffold,
      BuildContext context,
      this.uploadProgressCallback,
      bool showSnackbarForError}) {
    _showSnackbarForError = showSnackbarForError;
    assert(context != null,
        "Show Snackbar is true so you must provide the context");
    _context = context;
    if (showSnackbarForError) {
      assert(scaffold != null,
          "Show Snackbar is true so you must provide the scaffold");
      _scaffold = scaffold;
    }
  }

  Future postWithoutSecretKey(
      {String url, FormData body, bool storeUserData}) async {
    print(url);
    print(body);
    try {
      bool checkConnection = await _checkConnection();
      if (!checkConnection) {
        return NO_CONNECTION;
      }

      Response response = await Dio().post(url, data: body,
          onSendProgress: (int send, int total) {
        if (uploadProgressCallback != null)
          uploadProgressCallback(uploadProgressPercentage(send, total));
      },
          options: Options(
            headers: {
              "Accept": "application/json",
            },
            validateStatus: (status) {
              return status < 500;
            },
          ));

      print(response.data);
      print(response.statusCode);

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        if (storeUserData) {
//          }
        } else
          return response;
      } else
        _serverResponse(response);
    } catch (e) {
      print("ERROR! postWithoutTokenAndStoreUserData $e");
      return null;
    }
  }

  static Future getSimple({String url}) async {
    print("GET SIMPPLE $url");
    ///Make an api call
    Dio dio = Dio();
    Response response = await dio.get(url,
        options: Options(
          headers: {
            SECRET_KEY: SECRET_VALUE,
            "Content-Type": "application/json"
          },
          receiveTimeout: 5000,
          validateStatus: (status) {
            return status < 500;
          },
        ));

    print(response.data);
    print(response.statusCode);

    return response;
  }

  Future get({String url}) async {
    print("GET $url");

    ///check internet Connectivity

    try{
      bool checkConnection = await _checkConnection();
      if (!checkConnection) {
        return NO_CONNECTION;
      }

      ///Make an api call
      Dio dio = Dio();
      Response response = await dio.get(url,
          options: Options(
            headers: {
              SECRET_KEY: SECRET_VALUE,
              "Content-Type": "application/json"
            },
             receiveTimeout: 5000,
            // validateStatus: (status) {
            //   return status < 500;
            // },
          ));

      print(response.data);
      print(response.statusCode);

      return _serverResponse(response);
    } on SocketException {
      return NO_CONNECTION;
    }
    catch(e){
      print("exception throw${e.toString()}");
      return false;
    }
  }

  Future put({String url, var body, String contentType}) async {
    try {
      print("Put $url");
      print(contentType);

      bool checkConnection = await _checkConnection();
      if (!checkConnection) {
        return NO_CONNECTION;
      }

//      String token = await UserModel.getToken();

      Response response = await Dio().put(url, data: body,
          onSendProgress: (int send, int total) {
        if (uploadProgressCallback != null)
          uploadProgressCallback(uploadProgressPercentage(send, total));
      },
          options: Options(
            headers: {SECRET_KEY: SECRET_VALUE, "Accept": "application/json"},
            receiveTimeout: 5000,
            contentType: contentType != null ? contentType : null,
            validateStatus: (status) {
              return status < 500;
            },
          ));
      print(response.data);
      print(response.statusCode);

      return _serverResponse(response);
    } catch (e) {
      print("Post API ERROR $e");
      return null;
    }
  }

  Future post({String url, var body, String contentType}) async {
    try {
      print("POST $url");

//      body.fields.forEach((field) => print(field.key + " " + field.value));
//      if (body is FormData) {
//        print(body.length);
//        print(body.isFinalized);
//        body.fields.forEach((field)=>print(field.key+" "+field.value));
//        body.files.forEach((file){print(file.key);
//        print(file.value.contentType);
//        print(file.value.filename);
//        });
////        if(!body.isFinalized)
////          body.finalize();
//      }

      bool checkConnection = await _checkConnection();
      if (!checkConnection) {
        return NO_CONNECTION;
      }

//      String token = await UserModel.getToken();

      Response response = await Dio().post(url, data: body,
          onSendProgress: (int send, int total) {
        if (uploadProgressCallback != null)
          uploadProgressCallback(uploadProgressPercentage(send, total));
      },
          options: Options(
            headers: {SECRET_KEY: SECRET_VALUE, "Accept": "application/json"},
            contentType: contentType != null ? contentType : null,
            validateStatus: (status) {
              return status <= 500;
            },
          ));

      print(response.data);
      print(response.statusCode);

      return _serverResponse(response);
    } catch (e) {
      print("Post API ERROR $e");
      return null;
    }
  }

  _checkConnection() async {
    try {
      await InternetAddress.lookup(CHECK_INTERNET_CONNECTION);
      return true;
    } on SocketException  {
      print("Socket Exception");
      return false;
    }
  }

  Future _serverResponse(Response response) async {
    print(
        "Success ${response.statusCode >= 200 && response.statusCode <= 204}");
    if (response.statusCode >= 200 && response.statusCode <= 204)
      return response;
    else if (response.statusCode >= 400 &&
        response.statusCode < 500 &&
        response.statusCode != 404 &&
        response.statusCode != 405)
      return DebugError.CheckMap(
          response.data, _scaffold, _showSnackbarForError);
    else if (response.statusCode == 404) if (_showSnackbarForError)
      CustomSnackBar.SnackBar_3Error(_scaffold,
          leadingIcon: Icons.error_outline,
          title: TranslationBase.of(_context).contactSupport);
    else
      return TranslationBase.of(_context).contactSupport;
    else if (response.statusCode == 405) if (_showSnackbarForError)
      CustomSnackBar.SnackBar_3Error(_scaffold,
          leadingIcon: Icons.error_outline,
          title: TranslationBase.of(_context).methodNotAllowed);
    else
      return TranslationBase.of(_context).methodNotAllowed;
    else if (response.statusCode > 405 &&
        response.statusCode < 500) if (_showSnackbarForError)
      CustomSnackBar.SnackBar_3Error(_scaffold,
          leadingIcon: Icons.error_outline,
          title: "Code ${response.statusCode}");
    else
      return response.statusCode.toString();
    else if (response.statusCode == 500) if (_showSnackbarForError)
      CustomSnackBar.SnackBar_3Error(_scaffold,
          leadingIcon: Icons.error_outline,
          title: TranslationBase.of(_context).serverNotResponding);
    else
      return TranslationBase.of(_context).serverNotResponding;
    else if (_showSnackbarForError)
      CustomSnackBar.SnackBar_3Error(_scaffold,
          leadingIcon: Icons.error_outline,
          title: "Code ${response.statusCode}");
    else
      return response.statusCode.toString();
    return null;
  }

}
class simpleApi{
  Future post({String url, var body, String contentType}) async {
    try {
      print("POST $url");

      bool checkConnection = await _checkConnection();
      if (!checkConnection) {
        return NO_CONNECTION;
      }

//      String token = await UserModel.getToken();

      Response response = await Dio().post(url, data: body,
          onSendProgress: (int send, int total) {
//            if (uploadProgressCallback != null)
//              uploadProgressCallback(uploadProgressPercentage(send, total));
          },
          options: Options(
            headers: {SECRET_KEY: SECRET_VALUE, "Accept": "application/json"},
            contentType: contentType != null ? contentType : null,
            validateStatus: (status) {
              return status <= 500;
            },
          ));

      print(response.data);
      print(response.statusCode);

      return response;
    } catch (e) {
      print("Post API ERROR $e");
      return null;
    }
  }
  _checkConnection() async {
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    if (connectivityResult == ConnectivityResult.mobile ||
//        connectivityResult == ConnectivityResult.wifi) {
//      return true;
//    } else {
//      CustomSnackBar.SnackBar_ButtonError(_scaffold,
//          title: TranslationBase.of(_context).internetError,
//          leadingIcon: Icons.not_interested,
//          btnFun:
//            function
//          ,
//          buttonText: TranslationBase.of(_context).retry);
//      return false;
//    }

    try {
      await InternetAddress.lookup(CHECK_INTERNET_CONNECTION);
      return true;
    } on SocketException catch (e) {
      print("Socket Exception");
      return false;
    }
  }
}
