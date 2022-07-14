import 'package:doctor_app/getIt.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/pages/signIn.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/repeatedWidgets/filledButton.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';

class UpdatePasswordByToken extends StatefulWidget {
  final String phoneNumber;
  final String recentOTP;

  UpdatePasswordByToken({Key key, this.phoneNumber, this.recentOTP}) : super(key: key);

  @override
  _UpdatePasswordByTokenState createState() => _UpdatePasswordByTokenState();
}

class _UpdatePasswordByTokenState extends State<UpdatePasswordByToken> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  TextEditingController _controllerPass = TextEditingController();
  TextEditingController _controllerConfirmPass = TextEditingController();
  bool obscurepass = true;
  bool obscureConfirmPass = true;

  bool submitData = false;
  String errorMessage;

  ///0>signin
  ///1>signup
  ///2>forgetpassword
  int uiState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: _body(),
    );
  }

  _body() {
    Size size1 = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size1.longestSide * 0.0336749),
        padding: EdgeInsets.only(top: size1.longestSide * 0.1464128),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Update Password",
                        style: TextStyle(
                            color: Color(0xff2063C2),
                            fontFamily: "LatoRegular",
                            fontSize: size1.longestSide * 0.02342606)),
                  ),
                  IconButton(
                    iconSize: 18,
                    onPressed: () {
                      getIt<GlobalSingleton>()
                          .navigationKey
                          .currentState
                          .popUntil((route) => route.isFirst);
                      getIt<GlobalSingleton>()
                          .navigationKey
                          .currentState
                          .push(PageTransition(type: PageTransitionType.fade, child: HomePage()));
                      // getIt<GlobalSingleton>().navigationKey.currentState.pop();
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.11713030,
            ),
            Container(
              height: size1.longestSide * 0.06734992,
              width: size1.longestSide * 0.2342606,
              child: SvgPicture.asset(
                "assets/icons/logoChange.svg",
                height: 60,
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.04685212,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: "New Password",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "LatoRegular",
                            color: Colors.grey,
                          )),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.014641288,
            ),
            Container(
              child: CustomTextField(
                hints: "Enter New Password",
                // textInputType: TextInputType.text,
                textEditingController: _controllerPass,
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.025,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: "Confirm New Password",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "LatoRegular",
                            color: Colors.grey,
                          )),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.014641288,
            ),
            Container(
              child: CustomTextField(
                hints: "Repeat New Password",
                // textInputType: TextInputType.text,
                textEditingController: _controllerConfirmPass,
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.025,
            ),
            ErrorMessage(
              message: errorMessage,
            ),
            Container(
              child: submitData
                  ? Center(
                      child: Loading(),
                    )
                  : GestureDetector(
                      onTap: _validateForm,
                      child: Container(
                        child: filledButton(
                          txt: "Submit",
                          color1:
                              submitData ? Color(0xff19769f).withOpacity(0.5) : Color(0xff19769f),
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }

  _submitToServer() async {
    setState(() {
      submitData = true;
    });

    String url;
    Map body;

    url = UPDATE_NEW_PASSWORD;
    print('value fo widget.phoneNumber ++++ ----- ///////////////////////');
    print(widget.phoneNumber);
    // url = LOGIN_URL;
    body = {
      'phone_number': widget.phoneNumber,
      'new_password': _controllerPass.text,
      'recent_otp': widget.recentOTP
    };

    print('////////////// value fo body');
    print(body);

    var response =
        await API(scaffold: _scaffoldState, context: context, showSnackbarForError: false)
            .post(url: url, body: body);

    setState(() {
      submitData = false;
    });
    print('value fo response 999999999-----------');
    print(response);

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldState, context);
      return;
    }

    if (response is Response) {
      print('this condition is true response is Response');
      if (response.statusCode >= 200 && response.statusCode <= 202) {
        print('this conditon is true response.statusCode >= 200 && response.statusCode <= 202');
        getIt<GlobalSingleton>()
            .navigationKey
            .currentState
            .pushReplacement(PageTransition(type: PageTransitionType.fade, child: signIn()));
      } else {
        setState(() {
          errorMessage = response.toString();
        });
      }
    } else {
      setState(() {
        errorMessage = response.toString();
      });
    }
  }

  _validateForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    print('inside the _validateForm');
    setState(() {
      errorMessage = null;
    });
    if (_controllerConfirmPass.text == _controllerPass.text) {
      _submitToServer();
      // return true;
    } else {
      setState(() {
        errorMessage = "Password do not match. Try Again";
      });
    }
  }
}
