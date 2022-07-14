import 'package:dio/dio.dart';
import 'package:doctor_app/api/api.dart';
import 'package:doctor_app/api/api_name.dart';
import 'package:doctor_app/error/error_message_widget.dart';
import 'package:doctor_app/error/snackbar.dart';
import 'package:doctor_app/getIt.dart';
import 'package:doctor_app/model/server_body_model/appointment.dart';
import 'package:doctor_app/model/user_model.dart';
import 'package:doctor_app/pages/home.dart';
import 'package:doctor_app/pages/patientdetail.dart';
import 'package:doctor_app/pages/signIn.dart';
import 'package:doctor_app/pages/update_password.dart';
import 'package:doctor_app/repeatedWidgets/filledButton.dart';
import 'package:doctor_app/repeatedWidgets/loading.dart';
import 'package:doctor_app/res/color.dart';
import 'package:doctor_app/singleton/global.dart';
import 'package:doctor_app/transulation/translations_delegate_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:doctor_app/res/size.dart';

class VerifyNumberToForget extends StatefulWidget {
  final String number;
  // final String password;
  // final String otpToken;
  // final CreateAppointment appointment;

  const VerifyNumberToForget({Key key, this.number}) : super(key: key);

  @override
  _VerifyNumberToForgetState createState() => _VerifyNumberToForgetState();
}

class _VerifyNumberToForgetState extends State<VerifyNumberToForget> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedItem = "salaam";

  bool submit = false;
  bool otpResend = false;

  TextEditingController _controller = TextEditingController();
  String numberText = "";

  double _progressValue = 0;
  String errorMessage;

  @override
  void initState() {
    super.initState();
    int length = 0;
    if (widget.number != null)
      widget.number.split('').forEach((str) {
        if (widget.number.indexOf(str, length) % 3 == 0)
          numberText += " " + str;
        else
          numberText += str;
        length++;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _body(),
    );
  }

  _body() {
    Size size1 = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(top: size1.longestSide * 0.1229868),
        width: size1.width,
        height: size1.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff19769f), Color(0xff35d8a6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size1.longestSide * 0.03367496),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(
                        text: TranslationBase.of(context).messagesent,
                        style: TextStyle(
                            fontFamily: "Lato-Regular", fontSize: 14, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        textDirection: TextDirection.ltr,
                        text: TextSpan(
                            text: numberText,
                            style: TextStyle(
                                fontFamily: "Lato-Regular", fontSize: 14, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: size1.longestSide * 0.278184480,
                  child: Image.asset("assets/icons/undraw_message_sent_1030.png"),
                ),
                SizedBox(
                  height: size1.longestSide * 0.0527086383,
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                        text: TranslationBase.of(context).enterVerificationCode,
                        style: TextStyle(
                            fontFamily: "Lato-Regular", fontSize: 14, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  child: RichText(
                    textDirection: TextDirection.ltr,
                    text: TextSpan(
                        text: numberText,
                        style: TextStyle(
                            fontFamily: "Lato-Regular", fontSize: 14, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PinCodeTextField(
                    // textDirection:TextDirection.ltr,

                    length: 6,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.box,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: size1.longestSide * 0.061493411,
                    fieldWidth: size1.longestSide * 0.061493411,
                    onCompleted: (val) {
                      _verifyNumber();
                    },
                    controller: _controller,
                    backgroundColor: Colors.white.withOpacity(0.0),
                    // backgroundColor: Colors.transparent,
                    activeColor: Colors.white,
                    selectedColor: Colors.white,
                    disabledColor: Colors.white,
                    inactiveColor: Colors.white,
                    borderWidth: 1.2,
                    //mainAxisAlignment: MainAxisAlignment.,
                    textInputType: TextInputType.numberWithOptions(),

                    onChanged: (value) {},
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                ErrorMessage(
                  message: errorMessage,
                ),
//                Container(
//                  child: RichText(
//                    text: TextSpan(
//                        text: TranslationBase.of(context).selectNetwork,
//                        style: TextStyle(
//                            fontFamily: "Lato-Regular",
//                            fontSize: 14,
//                            color: Colors.white)),
//                  ),
//                ),
//                SizedBox(
//                  height: 20,
//                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      Expanded(
//                        child: Container(
//                            child: dropDown(
//                          paddingTop: 0.1,
//                          width: size.convertWidth(context, 165),
//                          height: size.convert(context, 40),
//                          itemList: [
//                            "salaam",
//                            "etisalat",
//                            "MTN",
//                            "AWCC",
//                            "Roshan",
//                          ],
//                          selectedItem: selectedItem,
//                          onItemSelect: (val) {
//                            selectedItem = val;
//                          },
//                          selectedColor: Colors.white,
//                          ContColor: Colors.transparent,
//                          BorderColor: Colors.white,
//                        )),
//                      ),
//                      SizedBox(
//                        width: 18,
//                      ),
                      Expanded(
                        child: otpResend
                            ? Center(
                                child: Loading(),
                              )
                            : GestureDetector(
                                onTap: otpResend ? null : _resendOTP,
                                child: Container(
                                  width: size1.longestSide * 0.29868228,
                                  height: size1.longestSide * 0.05878038067,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: otpResend
                                          ? Color(0xff19769f).withOpacity(0.8)
                                          : Color(0xff19769f)),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                          text: TranslationBase.of(context).resentotp,
                                          style: TextStyle(
                                              fontFamily: "LatoBold",
                                              fontSize: 10,
                                              color: Colors.white)
//                           ,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: submit
                      ? Center(
                          child: CircularPercentIndicator(
                            backgroundColor: Colors.transparent,
                            progressColor: buttonColor,
                            percent: _progressValue?.toDouble() ?? 0.0,
                            radius: size.convert(context, 40),
                            center: Center(
                              child: Text(
                                "${(_progressValue * 100).toInt()}",
                                style: TextStyle(
                                    fontSize: size.convert(context, 16), color: buttonColor),
                              ),
                            ),
                            lineWidth: size.convert(context, 3),
                            animation: false,
                            animationDuration: 100,
                          ),
                        )
                      : GestureDetector(
                          onTap: submit ? null : _verifyNumber,
//                        () {
//                      print("Verify and Sign up");
//                    },
                          child: filledButton(
                            color1: submit ? Color(0xff19769f).withOpacity(0.8) : Color(0xff19769f),
                            txt: TranslationBase.of(context).verifyandSignUp,
                            txtcolor: Colors.white,
                            fontsize: 12,
                            fontfamily: "LatoRegular",
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      print("Need help? Call us");
                    },
                    child: Container(
                      child: filledButton(
                        color1: Colors.transparent,
                        txt: TranslationBase.of(context).needHelp,
                        txtcolor: Colors.white,
                        fontsize: 12,
                        fontfamily: "LatoRegular",
                        borderwidth: 1,
                        borderColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.convert(context, 50),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _resendOTP() async {
    setState(() {
      otpResend = true;
    });
    Map body;
    body = {'Phone_number': widget.number};
    print(body);

    var response = await API(scaffold: _scaffoldKey, context: context, showSnackbarForError: true)
        .post(url: PHONE_NUMBER_URL, body: body);
    setState(() {
      otpResend = false;
    });

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldKey, context);
      return;
    }

    if (response is Response) {
      CustomSnackBar.SnackBar_3Success(_scaffoldKey,
          title: TranslationBase.of(context).coderesend, leadingIcon: Icons.check);
    }
  }

  _verifyNumber() async {
    setState(() {
      submit = true;
    });
    setState(() {
      errorMessage = null;
    });

    // Check if otp is correct
    // Map body = {'phone_number': widget.number, 'otp_token': _controller.text};
    Map body = {'phone_number': widget.number, 'v_code': _controller.text};
    print(body);

    var response = await API(
            scaffold: _scaffoldKey,
            context: context,
            uploadProgressCallback: (value) {
              setState(() {
                _progressValue = value;
              });
            },
            showSnackbarForError: true)
        .post(url: PHONE_VERIFICATION_URL, body: body);

    setState(() {
      submit = false;
    });
    print('the otp has been sent to server');
    print(response);
    print('///////////////');
    print('vlaue of phone number');
    print(widget.number);
    // print(response.body);

    if (response == NO_CONNECTION) {
      CustomSnackBar.SnackBarInternet(_scaffoldKey, context);
      return;
    }

    if (response is Response) {
      if (response.statusCode >= 200 && response.statusCode <= 202) {
        // _registerUser();
        // Elbis Updation
        getIt<GlobalSingleton>().navigationKey.currentState.popUntil((route) => route.isFirst);
        getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
            type: PageTransitionType.fade,
            child: UpdatePasswordByToken(
              phoneNumber: widget.number,
              recentOTP: _controller.text,
            )));
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

  // _registerUser() async {
  //   setState(() {
  //     submit = true;
  //   });

  //   Map body = {'mobile_number': widget.number, 'password': widget.password};

  //   var response = await API(scaffold: _scaffoldKey, context: context, showSnackbarForError: true)
  //       .post(url: REGISTER_URL, body: body);

  //   setState(() {
  //     submit = false;
  //   });

  //   if (response == NO_CONNECTION) {
  //     CustomSnackBar.SnackBarInternet(_scaffoldKey, context);
  //     return;
  //   }

  //   if (response is Response) {
  //     if (response.statusCode >= 200 && response.statusCode <= 202) {
  //       UserModel userModel = UserModel.fromJson(response.data);
  //       userModel.savePrefs();

  //       if (widget.appointment != null) {
  //         getIt<GlobalSingleton>().navigationKey.currentState.pop(); //pop verify number
  //         getIt<GlobalSingleton>().navigationKey.currentState.pop(); //pop signin UI

  //         getIt<GlobalSingleton>().navigationKey.currentState.push(PageTransition(
  //             type: PageTransitionType.leftToRight,
  //             child: patientDetail(
  //               appointment: widget.appointment,
  //             )));
  //       } else {
  //         getIt<GlobalSingleton>().navigationKey.currentState.popUntil((route) => route.isFirst);
  //         getIt<GlobalSingleton>()
  //             .navigationKey
  //             .currentState
  //             .push(PageTransition(type: PageTransitionType.fade, child: HomePage()));
  //       }
  //     }
  //   }
  // }
}
