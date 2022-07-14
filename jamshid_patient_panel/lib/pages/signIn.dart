import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/pages/verifyNumber.dart';
import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/model/server_body_model/appointment.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/patientdetail.dart';
import 'package:doctor_app/pages/verify_number_to_forget.dart';
import 'package:doctor_app/repeatedWidgets/CustomTextField.dart';
import 'package:doctor_app/repeatedWidgets/filledButton.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/res/size.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:doctor_app/validator/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../transulation/translations_delegate_base.dart';
import 'home.dart';

class signIn extends StatefulWidget {
  String clinicAdress;
  final CreateAppointment appointment;
  int clinicId;
  // String clinicId;

  signIn({Key key, this.appointment, this.clinicId, this.clinicAdress}) : super(key: key);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  TextEditingController _controllerNumber = TextEditingController();
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
                        text: uiState == 0
                            ? TranslationBase.of(context).signIn
                            : uiState == 1
                                ? TranslationBase.of(context).loginSignUpText
                                : TranslationBase.of(context).forgetPassword,
                        style: TextStyle(
                            color: Color(0xff2063C2),
                            fontFamily: "LatoRegular",
                            fontSize: size1.longestSide * 0.02342606)),
                  ),
                  IconButton(
                    iconSize: 18,
                    onPressed: () {
                      getIt<GlobalSingleton>().navigationKey.currentState.pop();
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
              height: size1.longestSide * 0.09734992,
              width: size1.longestSide * 0.5342606,
              // height: size1.longestSide * 0.06734992,
              // width: size1.longestSide * 0.2342606,
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
                          text: TranslationBase.of(context).numberhints,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "LatoRegular",
                            color: Color(0xff2063C2),
                            // color: Colors.blue,
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
                hints: "07XXXXXXXX",
                textInputType: TextInputType.number,
                textEditingController: _controllerNumber,
              ),
            ),
            uiState == 2
                ? Container()
                : SizedBox(
                    height: size1.longestSide * 0.02196193,
                  ),
            uiState == 2
                ? Container()
                : Container(
                    child: CustomTextField(
                      hints: TranslationBase.of(context).passwordhints,
                      textEditingController: _controllerPass,
                      obscureText: obscurepass,
                      trailingIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscurepass = !obscurepass;
                          });
                        },
                        child: Container(
                          child: obscurepass
                              ? Icon(
                                  IcoFontIcons.eyeBlocked,
                                  size: size.convert(context, 25),
                                  color: buttonColor,
                                )
                              : Icon(
                                  IcoFontIcons.eye,
                                  size: size.convert(context, 25),
                                  color: buttonColor,
                                ),
                        ),
                      ),
                    ),
                  ),
            uiState == 1
                ? SizedBox(
                    height: size1.longestSide * 0.02196193,
                  )
                : Container(),
            uiState == 1
                ? Container(
                    child: CustomTextField(
                      hints: TranslationBase.of(context).repasswordhints,
                      textEditingController: _controllerConfirmPass,
                      obscureText: obscureConfirmPass,
                      trailingIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureConfirmPass = !obscureConfirmPass;
                          });
                        },
                        child: Container(
                          child: obscureConfirmPass
                              ? Icon(
                                  IcoFontIcons.eyeBlocked,
                                  size: size.convert(context, 25),
                                  color: buttonColor,
                                )
                              : Icon(
                                  IcoFontIcons.eye,
                                  size: size.convert(context, 25),
                                  color: buttonColor,
                                ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: size1.longestSide * 0.025,
            ),
            GestureDetector(
              onTap: _toggleState,
              child: RichText(
                text: TextSpan(
                    text: uiState == 0
                        ? TranslationBase.of(context).createNewAccount
                        : TranslationBase.of(context).haveAnAccountSignIn,
                    style: TextStyle(
                        color: Color(0xff2063C2),
                        // color: Colors.blue,
                        fontFamily: "LatoRegular",
                        fontSize: size1.longestSide * 0.02342606)),
              ),
            ),
            SizedBox(
              height: size1.longestSide * 0.025,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  uiState = 2;
                });
              },
              child: RichText(
                text: TextSpan(
                    text: TranslationBase.of(context).forgetPassword,
                    style: TextStyle(
                        color: Color(0xff2063C2),
                        // color: Colors.blue,
                        fontFamily: "LatoRegular",
                        fontSize: size1.longestSide * 0.02342606)),
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
                          txt: TranslationBase.of(context).continuebuttonText,
                          color1:
                              submitData ? Color(0xff19769f).withOpacity(0.5) : Color(0xff19769f),
                        ),
                      )),
            )
          ],
        ),
      ),
    );
  }

  _toggleState() {
    setState(() {
      uiState = uiState == 2
          ? 0
          : uiState == 0
              ? 1
              : 0;
    });
  }

  _submitToServer() async {
    setState(() {
      submitData = true;
    });

    if (uiState == 2) {
      _forgetPassword();
      return;
    }

    String url;
    Map body;

    if (uiState == 1) {
//      url = REGISTER_URL;
      url = PHONE_NUMBER_URL;
      body = {'Phone_number': _controllerNumber.text};
    } else {
      url = LOGIN_URL;
      body = {'user_phone': _controllerNumber.text, 'user_pass': _controllerPass.text};
    }
    print(body);

    var response =
        await API(scaffold: _scaffoldState, context: context, showSnackbarForError: false)
            .post(url: url, body: body);

    setState(() {
      submitData = false;
    });

//    if (response == NO_CONNECTION) {
//      CustomSnackBar.SnackBarInternet(_scaffoldState, context);
//      return;
//    }

    if (response is Response) {
      if (response.statusCode >= 200 && response.statusCode <= 202) {
//        CustomSnackBar.SnackBar_3Success(_scaffoldState,
//            title: response.data, leadingIcon: Icons.check);
        if (uiState == 1) {
          getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
              type: PageTransitionType.leftToRight,
              child: verifyNumber(
                appointment: widget?.appointment,
                number: _controllerNumber.text,
                password: _controllerPass.text,
              )));
        } else {
          UserModel userModel = UserModel.fromJson(response.data['Patient_info']);

          userModel.savePrefs();

          if (widget.appointment != null) {
            getIt<GlobalSingleton>().navigationKey.currentState.pop();
            getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
                type: PageTransitionType.leftToRight,
                child: patientDetail(
                  appointment: widget.appointment,
                  clinicAdress: widget.clinicAdress,
                  clinicId: widget.clinicId,
                )));
          } else {
            getIt<GlobalSingleton>().navigationKey.currentState.popUntil((route) => route.isFirst);
            getIt<GlobalSingleton>()
                .navigationKey
                .currentState
                .push(PageTransition(type: PageTransitionType.fade, child: HomePage()));
          }
        }
      } else
        setState(() {
          errorMessage = response.toString();
        });
    } else
      setState(() {
        errorMessage = response.toString();
      });
  }

  _forgetPassword() async {
    var response =
        await API(scaffold: _scaffoldState, context: context, showSnackbarForError: false)
            .post(url: FORGET_PASSWORD_URL, body: {'phone_number': _controllerNumber.text});

    setState(() {
      submitData = false;
    });
    if (response is Response) {
      if (response.statusCode >= 200 && response.statusCode <= 202) {
        // Navigate to VerifyNumberToForget
        //
        getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
            type: PageTransitionType.leftToRight,
            child: VerifyNumberToForget(
              number: _controllerNumber.text,
              // otpToken: "the api response token",
            )));
        setState(() {
          uiState = 0;
        });

        CustomSnackBar.SnackBar_3Success(_scaffoldState,
            title: TranslationBase.of(context).sendPassword, leadingIcon: Icons.check);
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
    setState(() {
      errorMessage = null;
    });
    if (_controllerNumber.text.length < 10) {
      setState(() {
        errorMessage = TranslationBase.of(context).invalidNumber;
      });
      return false;
    } else if (_controllerPass.text.length < 6 && uiState != 2)
      setState(() {
        errorMessage = TranslationBase.of(context).passwordShort;
      });
    else if (_controllerConfirmPass.text != _controllerPass.text && uiState == 1)
      setState(() {
        errorMessage = TranslationBase.of(context).invalidConfirmPassword;
      });
    else
      _submitToServer();
  }
}
